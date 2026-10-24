-- ============================================================================
-- MazanDasht EPR OS — اسکیمای پایه (PostgreSQL 16)
-- نسخه سند: MD-DAT-002 / v1.0-draft
-- این فایل «قرارداد داده» را به اجرا تبدیل می‌کند. تغییر آن نیازمند ADR است.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 0) انواع شمارشی
-- ---------------------------------------------------------------------------
CREATE TYPE account_nature    AS ENUM ('D', 'C');
CREATE TYPE voucher_status    AS ENUM ('DRAFT','PENDING_APPROVAL','APPROVED','POSTED','REVERSED','VOID');
CREATE TYPE period_status     AS ENUM ('OPEN','SOFT_CLOSED','CLOSED','LOCKED');
CREATE TYPE ticket_direction  AS ENUM ('IN','OUT','RETURN');
CREATE TYPE ticket_status     AS ENUM ('DRAFT','WEIGHED','PRICED','APPROVED','POSTED','VOID','REVERSED');
CREATE TYPE invoice_status    AS ENUM ('DRAFT','CONFIRMED','POSTED','PARTIALLY_SETTLED','SETTLED','REVERSED','VOID');
CREATE TYPE move_type         AS ENUM ('IN_PURCHASE','IN_PRODUCTION','OUT_SALES','OUT_PRODUCTION',
                                       'TRANSFER_OUT','TRANSFER_IN','ADJUST_IN','ADJUST_OUT',
                                       'RETURN_IN','RETURN_OUT','WASTE');
CREATE TYPE move_status       AS ENUM ('DRAFT','APPROVED','POSTED','REVERSED');
CREATE TYPE party_role        AS ENUM ('GROWER','SUPPLIER','MARKET_TRADER','WHOLESALER','EXPORTER',
                                       'BROKER','DRIVER','EMPLOYEE','CUSTOMER_RETAIL');
CREATE TYPE item_type         AS ENUM ('FRUIT','CARTON','BASKET','PALLET','PACK_MATERIAL','SERVICE','FUEL','SPARE');
CREATE TYPE deduction_calc    AS ENUM ('PCT_OF_GROSS','PCT_OF_NET','FIXED');
CREATE TYPE import_status     AS ENUM ('UPLOADED','MAPPED','VALIDATED','REVIEWED','POSTING','POSTED','PARTIAL','ROLLED_BACK');
CREATE TYPE import_line_status AS ENUM ('NEW','DUPLICATE','SUSPICIOUS','INVALID','POSTED','SKIPPED');

-- ---------------------------------------------------------------------------
-- 1) سیستم، سازمان، کاربران
-- ---------------------------------------------------------------------------
CREATE TABLE core_company (
  id             uuid PRIMARY KEY,
  legal_name     varchar(256) NOT NULL,
  national_id    varchar(20),
  economic_code  varchar(20),
  address        text,
  logo_file_id   uuid,
  created_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE core_branch (
  id          uuid PRIMARY KEY,
  company_id  uuid NOT NULL REFERENCES core_company(id),
  code        varchar(16) NOT NULL,
  name_fa     varchar(120) NOT NULL,
  address     text,
  is_active   boolean NOT NULL DEFAULT true,
  UNIQUE (company_id, code)
);

CREATE TABLE sys_user (
  id             uuid PRIMARY KEY,
  username       varchar(60) NOT NULL UNIQUE,
  full_name      varchar(160) NOT NULL,
  password_hash  varchar(255) NOT NULL,
  mobile         varchar(20),
  is_active      boolean NOT NULL DEFAULT true,
  is_locked      boolean NOT NULL DEFAULT false,
  failed_count   smallint NOT NULL DEFAULT 0,
  last_login_at  timestamptz,
  password_changed_at timestamptz,
  created_at     timestamptz NOT NULL DEFAULT now(),
  created_by     uuid
);

CREATE TABLE sys_role (
  id        uuid PRIMARY KEY,
  code      varchar(40) NOT NULL UNIQUE,
  name_fa   varchar(120) NOT NULL,
  is_system boolean NOT NULL DEFAULT false
);

CREATE TABLE sys_role_permission (
  role_id      uuid NOT NULL REFERENCES sys_role(id) ON DELETE CASCADE,
  permission   varchar(80) NOT NULL,
  amount_limit numeric(20,4),
  PRIMARY KEY (role_id, permission)
);

CREATE TABLE sys_user_role (
  user_id   uuid NOT NULL REFERENCES sys_user(id) ON DELETE CASCADE,
  role_id   uuid NOT NULL REFERENCES sys_role(id),
  branch_id uuid REFERENCES core_branch(id),
  valid_from date,
  valid_to   date,
  PRIMARY KEY (user_id, role_id, branch_id)
);

CREATE TABLE sys_user_scope (
  user_id    uuid NOT NULL REFERENCES sys_user(id) ON DELETE CASCADE,
  scope_type smallint NOT NULL,           -- 1 BRANCH, 2 WAREHOUSE, 3 CASHBOX, 4 COST_CENTER, 5 SELF_ONLY, 6 AMOUNT_LIMIT
  scope_id   uuid,
  PRIMARY KEY (user_id, scope_type, scope_id)
);

CREATE TABLE sys_setting (
  key        varchar(120) PRIMARY KEY,
  value      jsonb NOT NULL,
  scope      varchar(40) NOT NULL DEFAULT 'GLOBAL',
  updated_at timestamptz NOT NULL DEFAULT now(),
  updated_by uuid
);

CREATE TABLE sys_audit_log (
  id             bigserial PRIMARY KEY,
  entity         varchar(64) NOT NULL,
  entity_id      uuid NOT NULL,
  action         varchar(24) NOT NULL,     -- CREATE/UPDATE/DELETE/POST/REVERSE/LOGIN...
  before_json    jsonb,
  after_json     jsonb,
  user_id        uuid,
  ip             inet,
  correlation_id varchar(64),
  at             timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ix_audit_entity ON sys_audit_log (entity, entity_id, at DESC);

CREATE TABLE sys_status_history (
  id         bigserial PRIMARY KEY,
  entity     varchar(64) NOT NULL,
  entity_id  uuid NOT NULL,
  from_status varchar(32),
  to_status   varchar(32) NOT NULL,
  reason      text,
  user_id     uuid NOT NULL,
  at          timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE sys_outbox (
  event_id    uuid PRIMARY KEY,
  event_type  varchar(64) NOT NULL,
  payload     jsonb NOT NULL,
  status      smallint NOT NULL DEFAULT 0,  -- 0 PENDING, 1 PUBLISHED, 2 FAILED
  retry_count smallint NOT NULL DEFAULT 0,
  created_at  timestamptz NOT NULL DEFAULT now(),
  published_at timestamptz
);
CREATE INDEX ix_outbox_pending ON sys_outbox (status, created_at) WHERE status = 0;

CREATE TABLE sys_idempotency (
  key         varchar(120) PRIMARY KEY,
  operation   varchar(80) NOT NULL,
  result_json jsonb NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  expires_at  timestamptz
);

CREATE TABLE sys_data_trace (
  id                uuid PRIMARY KEY,
  document_type     varchar(64) NOT NULL,
  document_id       uuid NOT NULL,
  source            varchar(40) NOT NULL,
  source_ref        varchar(300),
  raw_payload       jsonb,
  normalized_payload jsonb,
  identity_decisions jsonb,
  rules_applied     jsonb,
  actor_id          uuid,
  correlation_id    varchar(64),
  at                timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------------
-- 2) هسته: اشخاص، کالا، بسته‌بندی، واحد، انبار، ارز، سال مالی
-- ---------------------------------------------------------------------------
CREATE TABLE core_party (
  id                uuid PRIMARY KEY,
  code              varchar(32) NOT NULL,
  branch_id         uuid NOT NULL REFERENCES core_branch(id),
  name              varchar(256) NOT NULL,
  legal_name        varchar(256),
  national_id       varchar(20),
  economic_code     varchar(20),
  mobile            varchar(20),
  phone             varchar(30),
  address           text,
  credit_limit      numeric(20,4) NOT NULL DEFAULT 0,
  payment_term_days smallint NOT NULL DEFAULT 0,
  receivable_account_id uuid,
  payable_account_id    uuid,
  is_active         boolean NOT NULL DEFAULT true,
  is_blocked        boolean NOT NULL DEFAULT false,
  deleted_at        timestamptz,
  created_at        timestamptz NOT NULL DEFAULT now(),
  created_by        uuid NOT NULL,
  UNIQUE (branch_id, code)
);
CREATE INDEX ix_party_name ON core_party (name);
CREATE INDEX ix_party_mobile ON core_party (mobile);

CREATE TABLE core_party_role (
  party_id uuid NOT NULL REFERENCES core_party(id) ON DELETE CASCADE,
  role     party_role NOT NULL,
  PRIMARY KEY (party_id, role)
);

CREATE TABLE core_party_bank_account (
  id         uuid PRIMARY KEY,
  party_id   uuid NOT NULL REFERENCES core_party(id) ON DELETE CASCADE,
  bank_id    uuid,
  iban       varchar(26),
  account_no varchar(40),
  is_default boolean NOT NULL DEFAULT false,
  UNIQUE (party_id, iban)
);

CREATE TABLE core_uom (
  id        uuid PRIMARY KEY,
  code      varchar(16) NOT NULL UNIQUE,   -- KG, PCS, CARTON, PALLET
  name_fa   varchar(60) NOT NULL,
  decimals  smallint NOT NULL DEFAULT 0
);

CREATE TABLE core_item_group (
  id        uuid PRIMARY KEY,
  parent_id uuid REFERENCES core_item_group(id),
  code      varchar(24) NOT NULL UNIQUE,
  name_fa   varchar(120) NOT NULL
);

CREATE TABLE core_item (
  id                    uuid PRIMARY KEY,
  code                  varchar(24) NOT NULL UNIQUE,
  group_id              uuid REFERENCES core_item_group(id),
  name_fa               varchar(160) NOT NULL,
  item_type             item_type NOT NULL,
  base_uom_id           uuid NOT NULL REFERENCES core_uom(id),
  second_uom_id         uuid REFERENCES core_uom(id),
  is_weighted           boolean NOT NULL DEFAULT true,
  is_taxable            boolean NOT NULL DEFAULT false,
  is_tax_exempt         boolean NOT NULL DEFAULT true,
  inventory_account_id  uuid,
  sales_account_id      uuid,
  cogs_account_id       uuid,
  is_active             boolean NOT NULL DEFAULT true,
  created_at            timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE core_container_type (             -- سبد/کارتن
  id             uuid PRIMARY KEY,
  code           varchar(24) NOT NULL UNIQUE, -- BSK-RED, CTN-5KG
  name_fa        varchar(80) NOT NULL,
  item_type      item_type NOT NULL,
  standard_weight_kg numeric(10,3) NOT NULL DEFAULT 0,
  capacity_kg    numeric(10,3),
  cartons_per_pallet int,
  effective_from date NOT NULL DEFAULT '2020-01-01',
  effective_to   date
);

CREATE TABLE core_warehouse (
  id         uuid PRIMARY KEY,
  branch_id  uuid NOT NULL REFERENCES core_branch(id),
  code       varchar(16) NOT NULL,
  name_fa    varchar(120) NOT NULL,
  wh_type    smallint NOT NULL DEFAULT 1,     -- 1 انبار, 2 سردخانه, 3 سالن بسته‌بندی
  is_active  boolean NOT NULL DEFAULT true,
  UNIQUE (branch_id, code)
);

CREATE TABLE core_garden (
  id         uuid PRIMARY KEY,
  code       varchar(20) NOT NULL UNIQUE,
  name_fa    varchar(160) NOT NULL,
  party_id   uuid REFERENCES core_party(id),
  city_id    uuid,
  area_ha    numeric(10,2),
  is_active  boolean NOT NULL DEFAULT true
);

CREATE TABLE core_vehicle (
  id           uuid PRIMARY KEY,
  plate_no     varchar(20) NOT NULL UNIQUE,
  vehicle_type varchar(40),
  owner_party_id uuid REFERENCES core_party(id),
  capacity_kg  numeric(12,3),
  is_active    boolean NOT NULL DEFAULT true
);

CREATE TABLE core_currency (
  code           varchar(8) PRIMARY KEY,
  name_fa        varchar(60) NOT NULL,
  symbol         varchar(8),
  decimal_places smallint NOT NULL DEFAULT 2,
  is_base        boolean NOT NULL DEFAULT false,
  is_active      boolean NOT NULL DEFAULT true
);

CREATE TABLE core_currency_display_unit (
  id            uuid PRIMARY KEY,
  currency_code varchar(8) NOT NULL REFERENCES core_currency(code),
  code          varchar(12) NOT NULL,
  name_fa       varchar(40) NOT NULL,
  ratio         numeric(20,6) NOT NULL DEFAULT 1,
  decimal_places smallint NOT NULL DEFAULT 0,
  is_default    boolean NOT NULL DEFAULT false,
  UNIQUE (currency_code, code)
);

CREATE TABLE core_fiscal_year (
  id         uuid PRIMARY KEY,
  code       varchar(8) NOT NULL UNIQUE,     -- 1404
  start_date date NOT NULL,
  end_date   date NOT NULL,
  status     period_status NOT NULL DEFAULT 'OPEN'
);

CREATE TABLE core_fiscal_period (
  id             uuid PRIMARY KEY,
  fiscal_year_id uuid NOT NULL REFERENCES core_fiscal_year(id),
  code           varchar(7) NOT NULL,        -- 1404/07
  start_date     date NOT NULL,
  end_date       date NOT NULL,
  status         period_status NOT NULL DEFAULT 'OPEN',
  closed_at      timestamptz,
  closed_by      uuid,
  UNIQUE (fiscal_year_id, code)
);

-- ---------------------------------------------------------------------------
-- 3) حسابداری
-- ---------------------------------------------------------------------------
CREATE TABLE fin_account (
  id          uuid PRIMARY KEY,
  code        varchar(32) NOT NULL UNIQUE,
  parent_id   uuid REFERENCES fin_account(id),
  level       smallint NOT NULL CHECK (level BETWEEN 1 AND 4),
  group_code  smallint NOT NULL CHECK (group_code BETWEEN 1 AND 6),
  nature      account_nature NOT NULL,
  name_fa     varchar(200) NOT NULL,
  is_leaf     boolean NOT NULL DEFAULT true,
  currency_code varchar(8) REFERENCES core_currency(code),
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE fin_cost_center (
  id        uuid PRIMARY KEY,
  branch_id uuid NOT NULL REFERENCES core_branch(id),
  code      varchar(16) NOT NULL,
  name_fa   varchar(120) NOT NULL,
  UNIQUE (branch_id, code)
);

CREATE TABLE fin_voucher (
  id             uuid PRIMARY KEY,
  code           varchar(32) NOT NULL,
  branch_id      uuid NOT NULL REFERENCES core_branch(id),
  fiscal_year_id uuid NOT NULL REFERENCES core_fiscal_year(id),
  period_id      uuid NOT NULL REFERENCES core_fiscal_period(id),
  document_date  date NOT NULL,
  status         voucher_status NOT NULL DEFAULT 'DRAFT',
  source_type    varchar(64),
  source_id      uuid,
  description    varchar(500) NOT NULL,
  total_debit    numeric(20,4) NOT NULL DEFAULT 0,
  total_credit   numeric(20,4) NOT NULL DEFAULT 0,
  currency_code  varchar(8) NOT NULL DEFAULT 'IRR',
  fx_rate        numeric(20,10) NOT NULL DEFAULT 1,
  created_by     uuid NOT NULL,
  created_at     timestamptz NOT NULL DEFAULT now(),
  posted_by      uuid,
  posted_at      timestamptz,
  reversed_by_id uuid REFERENCES fin_voucher(id),
  hash_prev      varchar(64),
  hash_current   varchar(64),
  CONSTRAINT ck_voucher_balanced CHECK (total_debit = total_credit),
  UNIQUE (branch_id, fiscal_year_id, code)
);
CREATE INDEX ix_voucher_date ON fin_voucher (document_date);
CREATE INDEX ix_voucher_source ON fin_voucher (source_type, source_id);

CREATE TABLE fin_voucher_line (
  id             uuid PRIMARY KEY,
  voucher_id     uuid NOT NULL REFERENCES fin_voucher(id) ON DELETE RESTRICT,
  line_no        smallint NOT NULL,
  account_id     uuid NOT NULL REFERENCES fin_account(id),
  debit          numeric(20,4) NOT NULL DEFAULT 0,
  credit         numeric(20,4) NOT NULL DEFAULT 0,
  currency_code  varchar(8) NOT NULL DEFAULT 'IRR',
  amount_fx      numeric(20,4),
  description    varchar(500),
  party_id       uuid REFERENCES core_party(id),
  cost_center_id uuid REFERENCES fin_cost_center(id),
  garden_id      uuid REFERENCES core_garden(id),
  cold_room_id   uuid,
  vehicle_id     uuid REFERENCES core_vehicle(id),
  employee_id    uuid,
  CONSTRAINT ck_line_one_side CHECK ((debit > 0 AND credit = 0) OR (credit > 0 AND debit = 0)),
  UNIQUE (voucher_id, line_no)
);
CREATE INDEX ix_line_account ON fin_voucher_line (account_id);
CREATE INDEX ix_line_party ON fin_voucher_line (party_id) WHERE party_id IS NOT NULL;

CREATE TABLE fin_line_dimension (
  voucher_line_id uuid NOT NULL REFERENCES fin_voucher_line(id) ON DELETE CASCADE,
  dimension_type  varchar(32) NOT NULL,
  dimension_id    uuid NOT NULL,
  PRIMARY KEY (voucher_line_id, dimension_type, dimension_id)
);

CREATE TABLE fin_account_balance (
  account_id      uuid NOT NULL REFERENCES fin_account(id),
  period_id       uuid NOT NULL REFERENCES core_fiscal_period(id),
  branch_id       uuid NOT NULL REFERENCES core_branch(id),
  opening_debit   numeric(20,4) NOT NULL DEFAULT 0,
  opening_credit  numeric(20,4) NOT NULL DEFAULT 0,
  period_debit    numeric(20,4) NOT NULL DEFAULT 0,
  period_credit   numeric(20,4) NOT NULL DEFAULT 0,
  closing_debit   numeric(20,4) NOT NULL DEFAULT 0,
  closing_credit  numeric(20,4) NOT NULL DEFAULT 0,
  PRIMARY KEY (account_id, period_id, branch_id)
);

-- ---------------------------------------------------------------------------
-- 4) باسکول
-- ---------------------------------------------------------------------------
CREATE TABLE wb_device (
  id                 uuid PRIMARY KEY,
  code               varchar(20) NOT NULL UNIQUE,
  warehouse_id       uuid REFERENCES core_warehouse(id),
  protocol           varchar(20) NOT NULL DEFAULT 'TCP',
  endpoint           varchar(120),
  calibration_date   date,
  calibration_due    date,
  is_active          boolean NOT NULL DEFAULT true
);

CREATE TABLE wb_ticket (
  id                uuid PRIMARY KEY,
  code              varchar(32) NOT NULL,
  branch_id         uuid NOT NULL REFERENCES core_branch(id),
  direction         ticket_direction NOT NULL,
  business_date     date NOT NULL,
  vehicle_id        uuid NOT NULL REFERENCES core_vehicle(id),
  driver_id         uuid NOT NULL REFERENCES core_party(id),
  party_id          uuid NOT NULL REFERENCES core_party(id),
  garden_id         uuid REFERENCES core_garden(id),
  contract_id       uuid,
  item_id           uuid NOT NULL REFERENCES core_item(id),
  gross_weight_kg   numeric(14,3) NOT NULL CHECK (gross_weight_kg > 0),
  tare_weight_kg    numeric(14,3),
  vehicle_net_kg    numeric(14,3) NOT NULL,
  basket_count      int,
  basket_type_id    uuid REFERENCES core_container_type(id),
  basket_tare_kg    numeric(14,3) NOT NULL DEFAULT 0,
  waste_pct         numeric(9,4) NOT NULL DEFAULT 0,
  waste_kg          numeric(14,3) NOT NULL DEFAULT 0,
  net_weight_kg     numeric(14,3) NOT NULL,
  formula_version   varchar(20) NOT NULL DEFAULT 'F-01/v1',
  scale_id          uuid REFERENCES wb_device(id),
  is_manual_weight  boolean NOT NULL DEFAULT false,
  manual_reason     varchar(200),
  warehouse_id      uuid REFERENCES core_warehouse(id),
  cold_room_id      uuid,
  lot_id            uuid,
  invoice_id        uuid,
  status            ticket_status NOT NULL DEFAULT 'DRAFT',
  qr_payload        varchar(300),
  barcode           varchar(40),
  remark            text,
  source_node       varchar(20) NOT NULL DEFAULT 'SRV',
  created_by        uuid NOT NULL,
  created_at        timestamptz NOT NULL DEFAULT now(),
  approved_by       uuid,
  posted_at         timestamptz,
  CONSTRAINT ck_wb_net_positive CHECK (net_weight_kg > 0),
  CONSTRAINT ck_wb_tare CHECK (tare_weight_kg IS NULL OR tare_weight_kg < gross_weight_kg),
  UNIQUE (branch_id, code)
);
CREATE INDEX ix_wb_date ON wb_ticket (business_date, direction);
CREATE UNIQUE INDEX uq_wb_one_open_per_vehicle ON wb_ticket (vehicle_id)
  WHERE status IN ('DRAFT','WEIGHED');

-- ---------------------------------------------------------------------------
-- 5) موجودی
-- ---------------------------------------------------------------------------
CREATE TABLE inv_cold_room (
  id                uuid PRIMARY KEY,
  warehouse_id      uuid NOT NULL REFERENCES core_warehouse(id),
  code              varchar(20) NOT NULL,
  name_fa           varchar(80) NOT NULL,
  capacity_kg       numeric(14,3),
  target_temp_c     numeric(5,2),
  target_humidity_pct numeric(5,2),
  UNIQUE (warehouse_id, code)
);

CREATE TABLE inv_lot (
  id             uuid PRIMARY KEY,
  lot_no         varchar(32) NOT NULL UNIQUE,
  item_id        uuid NOT NULL REFERENCES core_item(id),
  garden_id      uuid REFERENCES core_garden(id),
  party_id       uuid REFERENCES core_party(id),
  source_ticket_id uuid REFERENCES wb_ticket(id),
  parent_lot_id  uuid REFERENCES inv_lot(id),
  received_date  date NOT NULL,
  qty_in_kg      numeric(14,3) NOT NULL,
  qty_remaining_kg numeric(14,3) NOT NULL,
  cost_per_kg    numeric(20,4) NOT NULL DEFAULT 0,
  is_closed      boolean NOT NULL DEFAULT false,
  created_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE inv_stock_move (
  id               uuid PRIMARY KEY,
  move_no          varchar(32) NOT NULL,
  branch_id        uuid NOT NULL REFERENCES core_branch(id),
  move_type        move_type NOT NULL,
  warehouse_id     uuid NOT NULL REFERENCES core_warehouse(id),
  cold_room_id     uuid REFERENCES inv_cold_room(id),
  item_id          uuid NOT NULL REFERENCES core_item(id),
  lot_id           uuid REFERENCES inv_lot(id),
  qty              numeric(14,3) NOT NULL,
  uom_id           uuid NOT NULL REFERENCES core_uom(id),
  unit_cost        numeric(20,4) NOT NULL DEFAULT 0,
  business_date    date NOT NULL,
  status           move_status NOT NULL DEFAULT 'DRAFT',
  source_type      varchar(64) NOT NULL,
  source_id        uuid NOT NULL,
  transfer_group_id uuid,
  reversal_of_id   uuid REFERENCES inv_stock_move(id),
  created_by       uuid NOT NULL,
  created_at       timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT ck_move_qty CHECK (qty <> 0)
);
CREATE INDEX ix_move_stock ON inv_stock_move (item_id, warehouse_id, business_date);

-- ---------------------------------------------------------------------------
-- 6) فروش
-- ---------------------------------------------------------------------------
CREATE TABLE sal_invoice (
  id               uuid PRIMARY KEY,
  code             varchar(32) NOT NULL,
  branch_id        uuid NOT NULL REFERENCES core_branch(id),
  party_id         uuid NOT NULL REFERENCES core_party(id),
  salesperson_id   uuid,
  channel_code     varchar(24),
  business_date    date NOT NULL,
  due_date         date,
  price_basis      smallint NOT NULL DEFAULT 1,  -- 1 PER_KG, 2 PER_CARTON, 3 PER_PALLET
  gross_amount     numeric(20,4) NOT NULL DEFAULT 0,
  deduction_amount numeric(20,4) NOT NULL DEFAULT 0,
  addition_amount  numeric(20,4) NOT NULL DEFAULT 0,
  vat_amount       numeric(20,4) NOT NULL DEFAULT 0,
  net_payable      numeric(20,4) NOT NULL DEFAULT 0,
  paid_amount      numeric(20,4) NOT NULL DEFAULT 0,
  currency_code    varchar(8) NOT NULL DEFAULT 'IRR',
  fx_rate          numeric(20,10) NOT NULL DEFAULT 1,
  is_official      boolean NOT NULL DEFAULT false,
  is_export        boolean NOT NULL DEFAULT false,
  incoterm         varchar(8),
  status           invoice_status NOT NULL DEFAULT 'DRAFT',
  print_template_id uuid,
  invoice_hash     varchar(64),
  voucher_id       uuid REFERENCES fin_voucher(id),
  created_by       uuid NOT NULL,
  created_at       timestamptz NOT NULL DEFAULT now(),
  posted_at        timestamptz,
  UNIQUE (branch_id, code)
);
CREATE INDEX ix_sal_invoice_party ON sal_invoice (party_id, business_date);

CREATE TABLE sal_invoice_line (
  id              uuid PRIMARY KEY,
  invoice_id      uuid NOT NULL REFERENCES sal_invoice(id) ON DELETE RESTRICT,
  line_no         smallint NOT NULL,
  item_id         uuid NOT NULL REFERENCES core_item(id),
  lot_id          uuid REFERENCES inv_lot(id),
  cold_room_id    uuid REFERENCES inv_cold_room(id),
  grade           varchar(4),
  basket_count    int,
  basket_type_id  uuid REFERENCES core_container_type(id),
  basket_weight_kg numeric(14,3) NOT NULL DEFAULT 0,
  basket_tare_kg  numeric(14,3) NOT NULL DEFAULT 0,
  scale_weight_kg numeric(14,3) NOT NULL DEFAULT 0,
  waste_pct       numeric(9,4) NOT NULL DEFAULT 0,
  waste_kg        numeric(14,3) NOT NULL DEFAULT 0,
  net_weight_kg   numeric(14,3) NOT NULL DEFAULT 0,
  carton_count    int,
  pallet_count    int,
  unit_price      numeric(20,4) NOT NULL DEFAULT 0,
  line_amount     numeric(20,4) NOT NULL DEFAULT 0,
  cogs_per_kg     numeric(20,4),
  cogs_amount     numeric(20,4),
  UNIQUE (invoice_id, line_no)
);

CREATE TABLE sal_deduction_type (
  code         varchar(24) PRIMARY KEY,
  name_fa      varchar(80) NOT NULL,
  default_calc deduction_calc NOT NULL,
  default_rate numeric(9,4),
  account_id   uuid REFERENCES fin_account(id),
  sequence     smallint NOT NULL DEFAULT 99,
  is_active    boolean NOT NULL DEFAULT true
);

CREATE TABLE sal_deduction (
  id             uuid PRIMARY KEY,
  invoice_id     uuid NOT NULL REFERENCES sal_invoice(id) ON DELETE CASCADE,
  type_code      varchar(24) NOT NULL REFERENCES sal_deduction_type(code),
  sequence       smallint NOT NULL,
  calc_method    deduction_calc NOT NULL,
  rate           numeric(9,4),
  base_amount    numeric(20,4),
  amount         numeric(20,4) NOT NULL,
  account_id     uuid NOT NULL REFERENCES fin_account(id),
  cost_center_id uuid REFERENCES fin_cost_center(id),
  party_id       uuid REFERENCES core_party(id),
  reason         varchar(200)
);

-- ---------------------------------------------------------------------------
-- 7) Import Studio
-- ---------------------------------------------------------------------------
CREATE TABLE imp_template (
  id           uuid PRIMARY KEY,
  name         varchar(120) NOT NULL,
  source_type  smallint NOT NULL,
  fingerprint  varchar(64) NOT NULL,
  mapping_json jsonb NOT NULL,
  version      int NOT NULL DEFAULT 1,
  is_active    boolean NOT NULL DEFAULT true,
  created_by   uuid NOT NULL,
  created_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE imp_batch (
  id                uuid PRIMARY KEY,
  code              varchar(32) NOT NULL UNIQUE,
  source_type       smallint NOT NULL,
  account_id        uuid REFERENCES fin_account(id),
  template_id       uuid REFERENCES imp_template(id),
  file_id           uuid NOT NULL,
  row_count         int NOT NULL DEFAULT 0,
  new_count         int NOT NULL DEFAULT 0,
  duplicate_count   int NOT NULL DEFAULT 0,
  suspicious_count  int NOT NULL DEFAULT 0,
  invalid_count     int NOT NULL DEFAULT 0,
  status            import_status NOT NULL DEFAULT 'UPLOADED',
  created_by        uuid NOT NULL,
  created_at        timestamptz NOT NULL DEFAULT now(),
  posted_at         timestamptz
);

CREATE TABLE imp_batch_line (
  id              uuid PRIMARY KEY,
  batch_id        uuid NOT NULL REFERENCES imp_batch(id) ON DELETE CASCADE,
  row_no          int NOT NULL,
  raw_json        jsonb NOT NULL,
  normalized_json jsonb NOT NULL,
  status          import_line_status NOT NULL,
  classification  varchar(40),
  confidence      numeric(5,4),
  account_id      uuid REFERENCES fin_account(id),
  party_id        uuid REFERENCES core_party(id),
  amount_debit    numeric(20,4) NOT NULL DEFAULT 0,
  amount_credit   numeric(20,4) NOT NULL DEFAULT 0,
  business_date   date,
  external_ref    varchar(80),
  dedupe_key      varchar(120),
  voucher_id      uuid REFERENCES fin_voucher(id),
  review_note     text,
  UNIQUE (batch_id, row_no)
);
CREATE UNIQUE INDEX uq_imp_dedupe ON imp_batch_line (dedupe_key)
  WHERE dedupe_key IS NOT NULL AND status <> 'DUPLICATE';

-- ---------------------------------------------------------------------------
-- 8) کنترل‌های سطح دیتابیس (تضمین VIS-01 و VIS-03)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_voucher_immutable() RETURNS trigger AS $$
BEGIN
  IF OLD.status IN ('POSTED','REVERSED','VOID') THEN
    RAISE EXCEPTION 'BR-001: سند ثبت‌شده قابل تغییر یا حذف نیست (%)', OLD.code;
  END IF;
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_voucher_immutable
  BEFORE UPDATE OR DELETE ON fin_voucher
  FOR EACH ROW EXECUTE FUNCTION fn_voucher_immutable();

CREATE OR REPLACE FUNCTION fn_line_account_postable() RETURNS trigger AS $$
BEGIN
  IF (SELECT NOT is_leaf FROM fin_account WHERE id = NEW.account_id) THEN
    RAISE EXCEPTION 'BR-011: ثبت روی حساب سرفصل مجاز نیست';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_line_account_postable
  BEFORE INSERT OR UPDATE ON fin_voucher_line
  FOR EACH ROW EXECUTE FUNCTION fn_line_account_postable();

CREATE OR REPLACE FUNCTION fn_period_open() RETURNS trigger AS $$
BEGIN
  IF (SELECT status FROM core_fiscal_period WHERE id = NEW.period_id) IN ('CLOSED','LOCKED') THEN
    RAISE EXCEPTION 'BR-004: دوره بسته است';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_period_open
  BEFORE INSERT OR UPDATE ON fin_voucher
  FOR EACH ROW EXECUTE FUNCTION fn_period_open();

-- ---------------------------------------------------------------------------
-- 9) داده پایه حداقلی
-- ---------------------------------------------------------------------------
INSERT INTO core_currency (code, name_fa, symbol, decimal_places, is_base) VALUES
  ('IRR','ریال ایران','﷼',0,true),
  ('USD','دلار آمریکا','$',2,false),
  ('EUR','یورو','€',2,false),
  ('AED','درهم امارات','د.إ',2,false),
  ('TRY','لیر ترکیه','₺',2,false);

INSERT INTO core_uom (id, code, name_fa, decimals) VALUES
  (gen_random_uuid(),'KG','کیلوگرم',3),
  (gen_random_uuid(),'PCS','عدد',0),
  (gen_random_uuid(),'CARTON','کارتن',0),
  (gen_random_uuid(),'PALLET','پالت',0);

INSERT INTO sal_deduction_type (code, name_fa, default_calc, default_rate, sequence) VALUES
  ('PURITY','صافی',        'PCT_OF_GROSS', 0.75, 10),
  ('LOSS','افت توافقی',    'PCT_OF_GROSS', 0.00, 20),
  ('COMMISSION','کمیسیون', 'PCT_OF_GROSS', 0.50, 30),
  ('FREIGHT','حمل',        'FIXED',        NULL, 40),
  ('LOADING','بارگری',     'FIXED',        NULL, 50),
  ('CARTON','کارتن',       'FIXED',        NULL, 60),
  ('PACKAGING','بسته‌بندی','FIXED',        NULL, 70),
  ('LABOR','کارگر',        'FIXED',        NULL, 80),
  ('OTHER','سایر',         'FIXED',        NULL, 99);
