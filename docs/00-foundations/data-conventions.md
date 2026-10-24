# قراردادهای داده (Data Conventions)

سند مرجع: `MD-DAT-001` · نسخه ۱.۰ · مالک: معمار ERP · تأیید: حسابرس ارشد

این سند «قانون اساسی داده» است. هر جدول، ستون، API و گزارش باید از آن تبعیت کند. تخلف از آن، بدهی فنی است و در Code Review رد می‌شود.

---

## ۱. انواع داده استاندارد

| مفهوم | نوع PostgreSQL | نوع SQLite (نسخه سبک) | قاعده |
|---|---|---|---|
| شناسه | `uuid` (v7) | `TEXT` | مرتب بر زمان، قابل تولید در کلاینت آفلاین |
| کد نمایشی | `varchar(32)` | `TEXT` | یکتا در دامنه، تغییرناپذیر |
| پول | `numeric(20,4)` | `NUMERIC` | هرگز `float`/`double` |
| وزن (kg) | `numeric(14,3)` | `NUMERIC` | ۳ رقم اعشار |
| درصد | `numeric(9,4)` | `NUMERIC` | ۰ تا ۱۰۰ (یا ۱۰۰٫۵ برای اضافه‌بار با مجوز) |
| مقدار شمارشی | `smallint` | `INTEGER` | عدد (کارایی) + `smallint` |
| تاریخ کاری | `date` | `TEXT` (ISO) | میلادی؛ معادل شمسی محاسبه‌می‌شود |
| زمان رخداد | `timestamptz` | `TEXT` (ISO8601) | UTC؛ نمایش در منطقه `Asia/Tehran` |
| متن کوتاه | `varchar(n)` | `TEXT` | `n` ≤ ۲۵۶ مگر متن حقوقی |
| متن بلند | `text` | `TEXT` | شرح، یادداشت |
| JSON ساخت‌یافته | `jsonb` | `TEXT` (JSON) | فقط برای داده بدون کوئری تحلیلی |
| بولی | `boolean` | `INTEGER` | — |
| فایل | ارجاع `doc_attachment.id` | همان | فایل در Object Storage/دیسک، نه DB |

### ۱.۱ قاعده «یک حقیقت، یک جا»
هیچ مقدار مشتق‌شده‌ای که در گزارش‌ها استفاده می‌شود، بدون ثبت صریح در جدول مربوطه، در چند جا محاسبه نمی‌شود. اگر مشتق گران است (مثل بهای تمام‌شده)، در لحظه رخداد **Snapshot** می‌شود.

| مقدار مشتق | منبع | محل ذخیره |
|---|---|---|
| وزن خالص | `gross−tare−basket−waste` | `wb_ticket.net_weight_kg` (Snapshot) |
| بهای تمام‌شده هر کیلو | تخصیص هزینه‌ها | `inv_lot.cost_per_kg` (Snapshot در بستن لات) |
| مانده حساب | مجموع خطوط | `fin_account_balance` (Materialized، بازسازی‌پذیر) |
| موجودی | مجموع حرکات | `inv_stock_balance` (Materialized، بازسازی‌پذیر) |
| مبلغ فاکتور | مجموع ردیف‌ها | `sal_invoice.total` (Snapshot با محاسبه مجدد در تأیید) |

> هر Snapshot باید تابع بازسازی داشته باشد: `fn_rebuild_*` و تست «بازسازی = مقدار ذخیره‌شده».

---

## ۲. کلیدها و یکتایی

| قاعده | جزئیات |
|---|---|
| PK | `id uuid` در همه جداول دامنه |
| Business Key | `code` یکتا در محدوده شعبه/سال مالی (نه سراسری، مگر کالا/شخص) |
| Natural Unique | ترکیب‌های `UNIQUE` صریح (مثل `(branch_id, code)`) |
| Idempotency | `idempotency_key varchar(80) UNIQUE` در جداول دریافت‌کننده رویداد/ورودی خارجی |
| External Ref | `external_ref` برای شناسه بانک/باسکول/دستگاه |
| FK | همه روابط با FK؛ حذف والد ممنوع (RESTRICT) برای داده مالی |

### ۲.۱ شناسه‌های آفلاین
کلاینت آفلاین باید بتواند رکورد بسازد. الگو: UUIDv7 که بایت‌های ابتدایی آن شامل `node_id` (۳۲ بیت) است تا تعارض ناممکن شود. سرور همیشه UUID را می‌پذیرد؛ تعارض فقط در Business Key ممکن است که با قاعده «پیشوند گره» حل می‌شود:

```
code = <prefix>-<node_code>-<seq>       مثال: CUS-A01-000482
```
در حالت آنلاین، `node_code` حذف و شماره سراسری تخصیص می‌یابد (تبدیل در زمان همگام‌سازی، با ثبت نگاشت).

---

## ۳. زمان و تقویم

| موضوع | تصمیم |
|---|---|
| ذخیره | `timestamptz` یوتی‌تی‌سی + `business_date date` (تاریخ محلی) |
| نمایش | شمسی، منطقه `Asia/Tehran` (UTC+3:30، بدون DST) |
| سال مالی | شمسی؛ `fiscal_year.code = '1404'` |
| شروع/پایان | `core_fiscal_year.start_date`, `end_date` (میلادی معادل) |
| تاریخ سند vs تاریخ رخداد | `document_date` (تاریخ حسابداری، قابل انتخاب تا امروز/دوره باز) و `event_at` (زمان واقعی) |
| ممنوعیت Future Date | `document_date > today + 1` نیازمند مجوز `PRM.sys.future_date` |
| تبدیل شمسی | کتابخانه `PersianCalendar` در Backend و `dayjs-jalali` در Frontend؛ تست مرزی ۲۹/۳۰ اسفند و سال کبیسه |
| نمایش زمان | `1404/07/18 07:12` (۲۴ ساعته) |

> **قاعده طلایی:** هرگز تاریخ شمسی را به‌صورت رشته در DB ذخیره نکن؛ فقط `business_date` میلادی + محاسبه. رشته شمسی فقط در ویو گزارش و چاپ.

---

## ۴. پول و ارز

| موضوع | تصمیم |
|---|---|
| ارز پایه | `IRR` با `decimal_places = 0` در نمایش، محاسبه با ۴ اعشار |
| واحد نمایش | تومان پیش‌فرض؛ `core_currency.display_unit = 'TOMAN'` با نسبت ۱۰ |
| ذخیره مبلغ | `amount_base numeric(20,4)` همیشه به ارز پایه + `amount_fx` و `currency_id`, `fx_rate` |
| نرخ ارز | `core_exchange_rate(from,to,rate,effective_from)`؛ نرخ لحظه سند Snapshot می‌شود |
| گرد کردن | `ROUND_HALF_UP` در محاسبه، `BANKERS` فقط در تخصیص؛ سیاست `sys_rounding_policy` |
| تلورانس تراز | حداکثر `0.01` واحد پایه؛ بیشتر = خطای سند |
| نمایش منفی | `(۱٬۲۵۰٬۰۰۰)` در گزارش، `-1,250,000` در API |

---

## ۵. قواعد اعتبارسنجی مشترک

| کد | قاعده | پیام فارسی |
|---|---|---|
| DV-001 | مبلغ ردیف = وزن خالص × فی (تلورانس ۱ ریال) | «مبلغ ردیف با وزن و فی هم‌خوان نیست» |
| DV-002 | مجموع بدهکار = مجموع بستانکار | «سند تراز نیست؛ اختلاف: X» |
| DV-003 | تاریخ سند در دوره باز | «دوره ۱۴۰۴/۰۶ بسته است» |
| DV-004 | طرف حساب فعال | «این طرف حساب غیرفعال است» |
| DV-005 | موجودی کافی برای خروج | «موجودی کافی نیست: درخواست X، موجود Y» |
| DV-006 | فی > ۰ برای فروش (مگر نمونه/اهدایی با مجوز) | «فی نمی‌تواند صفر باشد» |
| DV-007 | افت بار ≤ سقف مجاز (پیش‌فرض ۱۰٪) | «افت بار بیش از حد مجاز؛ نیازمند تأیید» |
| DV-008 | وزن خالص > ۰ | «وزن خالص محاسبه‌شده صفر است» |
| DV-009 | کد ملی ۱۰ رقمی با رقم کنترل | «کد ملی نامعتبر» |
| DV-010 | شبا ۲۴ رقم و شروع `IR` | «شماره شبا نامعتبر» |
| DV-011 | تکراری نبودن فاکتور بر اساس `(party, date, total, ref)` | «فاکتور مشابه قبلاً ثبت شده» |
| DV-012 | قفل دوره و سال | «سال مالی ۱۴۰۳ بسته است» |

---

## ۶. Audit، نسخه‌بندی و حذف

| موضوع | تصمیم |
|---|---|
| حذف | Soft delete (`deleted_at`, `deleted_by`) برای داده غیرمالی؛ داده مالی: فقط `VOID`/Reversal |
| لاگ تغییر | `sys_audit_log(entity, entity_id, action, before jsonb, after jsonb, user_id, ip, at)` |
| زنجیره‌سازی | `hash_prev`, `hash_current` برای اسناد مالی حساس (تشخیص دستکاری) |
| تاریخچه وضعیت | `sys_status_history(entity, entity_id, from_status, to_status, reason, user_id, at)` |
| تغییر فرمول | `sys_formula(code, version, expression, effective_from, effective_to)` |
| نگهداشت | داده مالی: ۱۰ سال؛ لاگ: ۵ سال؛ فایل‌های چاپ: ۵ سال |

---

## ۷. قواعد کدگذاری و نام‌گذاری

| موضوع | قاعده | درست | غلط |
|---|---|---|---|
| جدول | `snake_case`، جمع نبودن، پیشوند ماژول | `sal_invoice_line` | `Invoices`, `sale_invoice` |
| ستون | `snake_case`، واحد در نام | `net_weight_kg` | `weight`, `netWeight` |
| بولی | `is_`, `has_` | `is_taxable` | `taxable_flag` |
| شمارشی | عدد + جدول Lookup یا `CHECK` | `status smallint` | `varchar` آزاد |
| ایندکس | `ix_<table>_<cols>` | `ix_sal_invoice_party_date` | `idx1` |
| کلید خارجی | `fk_<table>_<ref>` | `fk_sal_invoice_party` | — |
| ویو | `vw_` | `vw_trial_balance` | — |
| تابع | `fn_` | `fn_post_sales_invoice` | — |
| رویداد | `domain.entity.action` | `sales.invoice.posted` | `invoiceSaved` |

---

## ۸. الگوی چندشعبه‌ای و ابعاد تحلیلی

هر جدول عملیاتی باید `branch_id` داشته باشد. ابعاد تحلیلی در خطوط سند و حرکات انبار:

| بُعد | جدول | اجباری در |
|---|---|---|
| شعبه | `core_branch` | همه اسناد |
| مرکز هزینه | `fin_cost_center` | هزینه‌ها، حقوق، نگهداشت |
| پروژه | `fin_project` | قراردادهای خاص، صادرات |
| باغ | `core_garden` | خرید میوه، سود باغ |
| سردخانه/اتاق | `inv_cold_room` | ورود/خروج/نگهداشت |
| خودرو/راننده | `core_vehicle` | باسکول، کرایه |
| پرسنل | `hr_employee` | حقوق، کارگری |
| کانال فروش | `crm_channel` | فروش |
| محصول/رقم | `core_item`, `core_variety` | خرید/فروش/تولید |

**قاعده:** بُعدی که در سند خالی بماند، در گزارش «تخصیص‌نیافته» می‌شود و باید در بستن دوره صفر شود (گزارش `RPT-FIN-021`).

---

## ۹. همگام‌سازی و تعارض

| موضوع | تصمیم |
|---|---|
| جهت | دوطرفه برای داده‌های عملیاتی کلاینت (باسکول، انبار)، یک‌طرفه (سرور→کلاینت) برای داده پایه و اسناد مالی |
| واحد | Change-set با `revision` یکنوا در سرور |
| تضاد | آخرین‌نویسنده برنده **نیست**؛ برای اسناد مالی: «سرور برنده + ثبت تضاد برای بازبینی»؛ برای یادداشت/CRM: ادغام فیلدی |
| حذف | Tombstone با `deleted_at` منتقل می‌شود |
| ترتیب | FIFO بر اساس `client_seq`؛ اسناد وابسته در یک Change-set اتمیک |
| شناسه | UUIDv7 با `node_id`؛ Business Key با پیشوند گره |
| سلامت | هر کلاینت `sys_sync_state(last_revision, pending_count, last_error)` |

---

## ۱۰. نمونه DDL مرجع (برش عرضی)

```sql
CREATE TABLE core_party (
  id             uuid PRIMARY KEY,
  code           varchar(32) NOT NULL,
  branch_id      uuid NOT NULL REFERENCES core_branch(id),
  name           varchar(256) NOT NULL,
  legal_name     varchar(256),
  national_id    varchar(20),
  economic_code  varchar(20),
  mobile         varchar(20),
  phone          varchar(30),
  address        text,
  city_id        uuid REFERENCES core_city(id),
  credit_limit   numeric(20,4) NOT NULL DEFAULT 0,
  payment_term_days smallint NOT NULL DEFAULT 0,
  is_active      boolean NOT NULL DEFAULT true,
  is_blocked     boolean NOT NULL DEFAULT false,
  created_at     timestamptz NOT NULL DEFAULT now(),
  created_by     uuid NOT NULL,
  updated_at     timestamptz,
  updated_by     uuid,
  deleted_at     timestamptz,
  CONSTRAINT uq_core_party_code UNIQUE (branch_id, code)
);
CREATE INDEX ix_core_party_name ON core_party (name);
CREATE INDEX ix_core_party_mobile ON core_party (mobile);

CREATE TABLE core_party_role (
  party_id uuid NOT NULL REFERENCES core_party(id),
  role     smallint NOT NULL,          -- party_role enum
  PRIMARY KEY (party_id, role)
);
```

> DDL کامل در [data/](../data/README.md) و `database/schema.sql` نگهداری می‌شود؛ این بخش فقط مرجع سبک است.

---

## ۱۱. پذیرش

- [ ] هیچ ستون پولی از نوع `float` در اسکیمای نهایی نیست (تست اسکیمای خودکار).
- [ ] همه جداول مالی `branch_id`, `created_at`, `created_by` دارند.
- [ ] همه Snapshotها تابع بازسازی و تست برابری دارند.
- [ ] تبدیل تاریخ شمسی برای ۱۰ سال گذشته و ۵ سال آینده تست مرزی دارد.
- [ ] همه جداول دریافت‌کننده داده خارجی دارای `idempotency_key` یکتا هستند.
