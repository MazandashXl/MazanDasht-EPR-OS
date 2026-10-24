# لایه داده

| فایل/پوشه | محتوا |
|---|---|
| `schema.sql` | اسکیمای کامل پایه (PostgreSQL 16): جداول، انواع، قیدها، Triggerهای کنترلی، داده پایه |
| `seed/` | داده اولیه: حساب‌ها، نقش‌ها، سبد/کارتن، تنظیمات |
| `migrations/` | مایگریشن‌های نسخه‌دار (`NNNN_description.up.sql` / `.down.sql`) |
| `views/` | ویوها و Materialized Viewهای گزارش و BI |
| `functions/` | توابع بازسازی مانده، تخصیص هزینه، شماره‌گذاری |

## اجرا

```bash
createdb mazandasht
psql -d mazandasht -f schema.sql
psql -d mazandasht -f seed/chart_of_accounts.sql
psql -d mazandasht -f seed/roles.sql
psql -d mazandasht -f views/dashboard.sql
```

## قواعد

1. هیچ تغییری روی اسکیما بدون مایگریشن انجام نمی‌شود.
2. هر مایگریشن `up` و `down` دارد.
3. Triggerهای کنترلی مالی (`fin_voucher`, `fin_voucher_line`) حذف‌شدنی نیستند.
4. داده مالی هرگز به‌صورت فیزیکی حذف نمی‌شود.

مرجع طراحی: [docs/data](../docs/data/README.md) · [docs/accounting](../docs/accounting/accounting-engine.md)
