-- ============================================================================
-- ویوهای گزارش و BI — نسخه ۱.۰
-- قاعده: هیچ گزارشی، کوئری خام روی جداول عملیاتی نمی‌زند؛ از این ویوها می‌خواند.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- مانده هر طرف حساب (دریافتنی مثبت، پرداختنی منفی)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_party_balance AS
SELECT
  p.id                                   AS party_id,
  p.code,
  p.name,
  p.branch_id,
  COALESCE(SUM(l.debit - l.credit), 0)   AS balance_base,
  MAX(v.document_date)                   AS last_movement_date
FROM core_party p
LEFT JOIN fin_voucher_line l ON l.party_id = p.id
LEFT JOIN fin_voucher v      ON v.id = l.voucher_id AND v.status = 'POSTED'
GROUP BY p.id, p.code, p.name, p.branch_id;

-- ---------------------------------------------------------------------------
-- تراز آزمایشی ۴ ستونه
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_trial_balance AS
WITH movements AS (
  SELECT
    l.account_id,
    v.branch_id,
    SUM(l.debit)  AS debit,
    SUM(l.credit) AS credit
  FROM fin_voucher_line l
  JOIN fin_voucher v ON v.id = l.voucher_id
  WHERE v.status = 'POSTED'
  GROUP BY l.account_id, v.branch_id
)
SELECT
  a.code                                AS account_code,
  a.name_fa                             AS account_name,
  a.group_code,
  a.nature,
  m.branch_id,
  COALESCE(m.debit, 0)                  AS total_debit,
  COALESCE(m.credit, 0)                 AS total_credit,
  GREATEST(COALESCE(m.debit, 0) - COALESCE(m.credit, 0), 0)  AS closing_debit,
  GREATEST(COALESCE(m.credit, 0) - COALESCE(m.debit, 0), 0)  AS closing_credit
FROM fin_account a
LEFT JOIN movements m ON m.account_id = a.id
WHERE a.is_leaf = true
ORDER BY a.code;

-- ---------------------------------------------------------------------------
-- مانده موجودی به تفکیک کالا/انبار/لات (وزنی و شمارشی)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_stock_balance AS
SELECT
  m.item_id,
  m.warehouse_id,
  m.lot_id,
  m.branch_id,
  SUM(CASE WHEN m.move_type IN ('IN_PURCHASE','IN_PRODUCTION','TRANSFER_IN','ADJUST_IN','RETURN_IN')
           THEN m.qty ELSE -m.qty END)                 AS qty_on_hand,
  SUM(CASE WHEN m.move_type IN ('IN_PURCHASE','IN_PRODUCTION','TRANSFER_IN','ADJUST_IN','RETURN_IN')
           THEN m.qty * m.unit_cost ELSE -m.qty * m.unit_cost END) AS value_on_hand
FROM inv_stock_move m
WHERE m.status = 'POSTED'
GROUP BY m.item_id, m.warehouse_id, m.lot_id, m.branch_id;

-- ---------------------------------------------------------------------------
-- فروش روزانه (پایه داشبورد)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_daily_sales AS
SELECT
  i.business_date,
  i.branch_id,
  COUNT(DISTINCT i.id)          AS invoice_count,
  SUM(i.net_payable)            AS net_sales,
  SUM(i.deduction_amount)       AS deductions,
  SUM(il.cogs_amount)           AS cogs,
  SUM(il.net_weight_kg)         AS sold_kg
FROM sal_invoice i
LEFT JOIN sal_invoice_line il ON il.invoice_id = i.id
WHERE i.status IN ('POSTED','PARTIALLY_SETTLED','SETTLED')
GROUP BY i.business_date, i.branch_id;

-- ---------------------------------------------------------------------------
-- سود هر لات (پایه KPI-SAL-003 / KPI-SAL-007)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_lot_profit AS
SELECT
  lot.id                       AS lot_id,
  lot.lot_no,
  lot.item_id,
  lot.garden_id,
  lot.received_date,
  lot.cost_per_kg,
  SUM(il.net_weight_kg)        AS sold_kg,
  SUM(il.line_amount)          AS revenue,
  SUM(il.cogs_amount)          AS cogs,
  SUM(il.line_amount - COALESCE(il.cogs_amount, 0)) AS gross_profit
FROM inv_lot lot
LEFT JOIN sal_invoice_line il ON il.lot_id = lot.id
LEFT JOIN sal_invoice i       ON i.id = il.invoice_id AND i.status IN ('POSTED','PARTIALLY_SETTLED','SETTLED')
GROUP BY lot.id, lot.lot_no, lot.item_id, lot.garden_id, lot.received_date, lot.cost_per_kg;

-- ---------------------------------------------------------------------------
-- صف تأیید (برای نشانگر هدر)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_pending_approvals AS
SELECT 'sal_invoice' AS entity, i.id, i.code, i.business_date, i.branch_id, i.created_by
FROM sal_invoice i WHERE i.status = 'CONFIRMED'
UNION ALL
SELECT 'fin_voucher', v.id, v.code, v.document_date, v.branch_id, v.created_by
FROM fin_voucher v WHERE v.status = 'PENDING_APPROVAL';

-- ---------------------------------------------------------------------------
-- کنترل سلامت: خطوط بدون بُعد (RPT-FIN-021)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_unallocated_lines AS
SELECT
  v.id AS voucher_id,
  v.code,
  v.document_date,
  l.line_no,
  a.code AS account_code,
  a.name_fa AS account_name,
  l.debit,
  l.credit
FROM fin_voucher_line l
JOIN fin_voucher v ON v.id = l.voucher_id
JOIN fin_account a ON a.id = l.account_id
WHERE v.status = 'POSTED'
  AND a.group_code = 5                     -- حساب‌های هزینه
  AND l.cost_center_id IS NULL;

-- ---------------------------------------------------------------------------
-- کنترل سلامت: بازسازی و مقایسه مانده (fn_rebuild_balances)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_rebuild_balances(p_period_id uuid) RETURNS void AS $$
BEGIN
  TRUNCATE fin_account_balance;

  INSERT INTO fin_account_balance
    (account_id, period_id, branch_id, opening_debit, opening_credit,
     period_debit, period_credit, closing_debit, closing_credit)
  SELECT
    l.account_id,
    p.id,
    v.branch_id,
    0, 0,
    COALESCE(SUM(l.debit), 0),
    COALESCE(SUM(l.credit), 0),
    GREATEST(COALESCE(SUM(l.debit), 0) - COALESCE(SUM(l.credit), 0), 0),
    GREATEST(COALESCE(SUM(l.credit), 0) - COALESCE(SUM(l.debit), 0), 0)
  FROM fin_voucher_line l
  JOIN fin_voucher v       ON v.id = l.voucher_id AND v.status = 'POSTED'
  JOIN core_fiscal_period p ON p.id = v.period_id
  WHERE p.id = p_period_id
  GROUP BY l.account_id, p.id, v.branch_id;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------------------------
-- کنترل سلامت: تراز کلی (باید همیشه صفر باشد)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_balance_check AS
SELECT
  SUM(l.debit)  AS total_debit,
  SUM(l.credit) AS total_credit,
  SUM(l.debit) - SUM(l.credit) AS difference
FROM fin_voucher_line l
JOIN fin_voucher v ON v.id = l.voucher_id
WHERE v.status = 'POSTED';
