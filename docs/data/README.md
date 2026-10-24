# مدل داده کامل

سند مرجع: `MD-DAT-002` · نسخه ۱.۰ · مالک: معمار ERP · تأیید: حسابرس ارشد

این سند فهرست مرجع موجودیت‌هاست. DDL اجرایی در [`database/schema.sql`](../../database/schema.sql) و مایگریشن‌ها در `database/migrations/` نگه داشته می‌شوند.

---

## ۱. نمای کلی (ERD سطح ماژول)

```
                         ┌──────────────┐
                         │  sys_*       │ کاربر، نقش، مجوز، تنظیمات، Audit
                         └──────┬───────┘
                                │
┌──────────────┐        ┌───────▼────────┐        ┌──────────────┐
│ core_party   │◄───────┤  fin_voucher   ├───────►│ fin_account  │
│ (اشخاص/نقش)  │        │  + lines       │        │ (درخت حساب)  │
└──────┬───────┘        └───────▲────────┘        └──────────────┘
       │                        │ source_id
       │                ┌───────┴───────────────────────────────┐
       │                │                                       │
┌──────▼──────┐   ┌─────▼──────┐   ┌──────────┐   ┌───────────▼────┐
│ wb_ticket   │──►│ pur_invoice│   │sal_invoice│──►│ inv_stock_move │
│ (باسکول)    │   │ (خرید)     │   │ (فروش)   │   │ (موجودی)       │
└──────┬──────┘   └────────────┘   └────┬─────┘   └───────┬────────┘
       │                                │                 │
       │                        ┌───────▼──────┐   ┌──────▼───────┐
       │                        │ sal_deduction│   │  inv_lot     │
       │                        └──────────────┘   └──────┬───────┘
       │                                                  │
┌──────▼──────────────────────────────────────────┐   ┌───▼────────────┐
│ prd_sort_run / prd_pack_run (تولید و بسته‌بندی) │──►│ inv_stock_move │
└─────────────────────────────────────────────────┘   └────────────────┘

┌──────────┐  ┌───────────┐  ┌───────────┐  ┌──────────┐  ┌──────────┐
│ imp_*    │  │ trs_*     │  │ fin_cheque│  │ crm_*    │  │ hr_*     │
│ Import   │  │ خزانه     │  │ چک        │  │ مشتری    │  │ پرسنل    │
└──────────┘  └───────────┘  └───────────┘  └──────────┘  └──────────┘
```

---

## ۲. فهرست جدول‌ها

### ۲.۱ سیستم (`sys_`)

| جدول | نقش | کلیدهای مهم |
|---|---|---|
| `sys_user` | کاربر | `code`, `username`, `password_hash`, `is_active` |
| `sys_role` / `sys_role_permission` | نقش و مجوز | `code`, `permission`, `amount_limit` |
| `sys_user_role` | انتساب نقش | `(user_id, role_id, branch_id)` |
| `sys_user_scope` | دامنه داده | `(user_id, scope_type, scope_id)` |
| `sys_setting` | تنظیمات کلید-مقدار | `key`, `value`, `scope` |
| `sys_audit_log` | ردپای تغییر | `entity`, `entity_id`, `before`, `after`, `hash` |
| `sys_status_history` | تاریخچه وضعیت | `entity`, `entity_id`, `from`, `to`, `reason` |
| `sys_outbox` | صف رویداد | `event_id`, `type`, `payload`, `status` |
| `sys_idempotency` | ضد تکرار | `key`, `operation`, `result_json` |
| `sys_data_trace` | ردیابی داده | `document_id`, `source`, `raw_payload` |
| `sys_sync_state` | وضعیت گره | `node_id`, `last_revision`, `pending_count` |
| `sys_sync_conflict` | تضاد همگام‌سازی | `node_id`, `entity`, `local`, `remote` |
| `sys_formula` | فرمول‌ها | `code`, `version`, `expression`, `effective_from` |
| `sys_help_article` | مقالات راهنما | `page_code`, `title`, `body` |
| `sys_backup_log` | لاگ پشتیبان | `started_at`, `status`, `path`, `size` |

### ۲.۲ هسته مشترک (`core_`)

| جدول | نقش |
|---|---|
| `core_branch` | شعبه |
| `core_company` | شخصیت حقوقی، لوگو، کد اقتصادی |
| `core_party` | اشخاص و شرکت‌ها |
| `core_party_role` | نقش‌ها (چندنقشی) |
| `core_party_bank_account` | حساب بانکی طرف حساب |
| `core_item` | کالا (میوه، کارتن، سبد، پالت، خدمات) |
| `core_item_group` / `core_variety` | گروه کالا و رقم مرکبات |
| `core_container_type` | نوع سبد/کارتن با وزن استاندارد |
| `core_uom` | واحد اندازه‌گیری |
| `core_warehouse` | انبار |
| `core_garden` | باغ |
| `core_vehicle` | خودرو |
| `core_city` / `core_province` | جغرافیا |
| `core_currency` / `core_currency_display_unit` | ارز و واحد نمایش |
| `core_exchange_rate` | نرخ ارز نسخه‌دار |
| `core_fiscal_year` / `core_fiscal_period` | سال و دوره مالی |
| `core_bank` | بانک |
| `core_numbering` | شماره‌گذاری اسناد |
| `core_code_map` | نگاشت کد موقت گره آفلاین به کد نهایی |

### ۲.۳ مالی (`fin_`)

| جدول | نقش |
|---|---|
| `fin_account` | درخت حساب‌ها |
| `fin_cost_center`, `fin_project` | ابعاد |
| `fin_voucher` / `fin_voucher_line` | سند و خطوط |
| `fin_line_dimension` | ابعاد آزاد |
| `fin_account_balance` | مانده ماهانه |
| `fin_posting_rule` / `fin_posting_rule_line` | قواعد سند خودکار |
| `fin_voucher_link` | ارتباط اسناد |
| `fin_tax_rate` | نرخ مالیات |
| `fin_bank_reconciliation` | تطبیق بانکی |
| `fin_bank_statement` / `fin_bank_statement_line` | صورتحساب |
| `fin_period_close_exception` | استثنای بستن |
| `fin_receipt` / `fin_payment` / `fin_transfer` | خزانه |
| `fin_cheque` | چک |

### ۲.۴ عملیات

| پیشوند | جدول‌های کلیدی |
|---|---|
| `wb_` | `wb_ticket`, `wb_weighing`, `wb_gate_log`, `wb_queue`, `wb_device`, `wb_calibration`, `wb_print_log` |
| `pur_` | `pur_contract`, `pur_order`, `pur_invoice`, `pur_invoice_line`, `pur_advance` |
| `sal_` | `sal_price_board`, `sal_quotation`, `sal_order`, `sal_shipment`, `sal_invoice`, `sal_invoice_line`, `sal_deduction`, `sal_deduction_type`, `sal_return`, `sal_settlement` |
| `inv_` | `inv_stock_move`, `inv_stock_balance`, `inv_lot`, `inv_cold_room`, `inv_location`, `inv_count`, `inv_count_line`, `inv_reservation`, `inv_transfer` |
| `prd_` | `prd_work_order`, `prd_sort_run`, `prd_pack_run`, `prd_grade_output`, `prd_waste_log`, `prd_line`, `prd_shift`, `prd_downtime` |
| `imp_` | `imp_batch`, `imp_batch_line`, `imp_template`, `imp_template_version`, `imp_rule`, `imp_rule_suggestion` |
| `crm_` | `crm_profile`, `crm_contact`, `crm_interaction`, `crm_complaint`, `crm_credit_history`, `crm_segment` |
| `hr_` | `hr_employee`, `hr_contract`, `hr_attendance`, `hr_leave`, `hr_payroll_run`, `hr_payslip`, `hr_loan` |
| `ast_` | `ast_asset`, `ast_category`, `ast_depreciation`, `ast_maintenance`, `ast_disposal` |
| `bi_` | `bi_fact_sales`, `bi_fact_purchase`, `bi_fact_production`, `bi_fact_profit_lot`, `bi_dim_*`, `bi_kpi_definition` |
| `doc_` | `doc_attachment`, `doc_print_log`, `doc_template` |

---

## ۳. روابط کلیدی (متن به‌جای نمودار)

| رابطه | کاردینالیتی | قاعده |
|---|---|---|
| `wb_ticket` → `pur_invoice` | ۱ به ۰..۱ | هر قبض حداکثر یک فاکتور خرید |
| `sal_invoice` → `wb_ticket` (OUT) | ۱ به ۰..۱ | هر فاکتور حداکثر یک قبض خروج |
| `sal_invoice` → `inv_stock_move` | ۱ به n | یک حرکت به‌ازای هر ردیف فروش |
| `inv_lot` → `wb_ticket` | n به ۱ | لات از قبض می‌آید |
| `inv_lot` → `prd_sort_run` | ۱ به n | لات می‌تواند چند اجرا داشته باشد |
| `fin_voucher` → هر سند عملیاتی | ۱ به ۱ (منبع) | یک رویداد، یک سند |
| `core_party` → `fin_voucher_line` | ۱ به n | مانده طرف حساب |
| `core_item` → `core_container_type` | n به ۱ | نوع بسته‌بندی |
| `prd_pack_run` → `core_container_type` | n به ۱ | مصرف کارتن |

---

## ۴. قواعد یکپارچگی

| قاعده | پیاده‌سازی |
|---|---|
| هیچ حرکت انبار بدون سند مبدأ | `source_type`, `source_id` NOT NULL |
| هیچ سند بدون شعبه | `branch_id` NOT NULL در همه جداول عملیاتی |
| هیچ خط سند بدون حساب برگ | Trigger |
| هیچ حذف فیزیکی داده مالی | `ON DELETE RESTRICT` + Trigger |
| موجودی منفی ممنوع | Trigger با جمع حرکات |
| مانده حساب قابل بازسازی | `fn_rebuild_balances()` |
| ارزش موجودی = مانده حساب | تست شبانه |

---

## ۵. داده اولیه (Seed)

| داده | محتوا |
|---|---|
| حساب‌ها | درخت کامل [chart-of-accounts](../accounting/chart-of-accounts.md) |
| نقش‌ها | ۱۶ نقش [roles-matrix](../security/roles-matrix.md) |
| واحدها | kg، عدد، کارتن، پالت، بسته |
| سبدها | قرمز ۲٫۸، زرد ۳٫۱، مشکی ۲٫۵، آبی ۲٫۲ |
| کارتن‌ها | ۵ کیلویی، ۱۰ کیلویی، صادراتی |
| ارز | IRR (پایه)، TOMAN (نمایش)، USD، EUR، AED، TRY |
| بانک‌ها | ملت، ملی، تجارت، صادرات، سپه، پاسارگاد |
| مراکز هزینه | باسکول، سورت، بسته‌بندی، سردخانه، حمل، فروش، اداری |
| قواعد سند | ۳۰ قاعده [posting-scenarios](../accounting/posting-scenarios.md) |

---

## ۶. سیاست رشد داده

| موضوع | تصمیم |
|---|---|
| پارتیشن | `fin_voucher_line` ماهانه |
| آرشیو | سال‌های > ۵ سال به `archive` schema (همان مدل، فقط جدا) |
| ایندکس | بر اساس کوئری‌های واقعی، بازبینی فصلی |
| حجم هدف | ۲۰M خط سند در ۵ سال بدون افت > ۲۰٪ |

---

## ۷. پذیرش

- [ ] هر جدول `branch_id`, `created_at`, `created_by` دارد (مگر جدول‌های مرجع).
- [ ] همه FKها با `ON DELETE RESTRICT` برای داده مالی.
- [ ] `fn_rebuild_balances` و `fn_rebuild_stock` نتیجه یکسان با داده عملیاتی بدهند.
- [ ] اسکیما با `database/schema.sql` قابل ساخت از صفر است.
- [ ] داده Seed، یک سیستم قابل استفاده کامل بسازد.
