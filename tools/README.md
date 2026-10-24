# ابزارهای توسعه

| ابزار | کار |
|---|---|
| `check_docs.py` | بررسی پیوندهای شکسته، شناسه‌های تکراری، وجود بخش «پذیرش» و آمار مستندات |
| `gen_seed.py` | تولید `database/seed/chart_of_accounts.sql` و `roles.sql` از تعریف فشرده |
| `validate_sql.sh` | اعتبارسنجی سینتکس SQL با `pglast` (نیازمند venv) |

## اجرا

```bash
python3 tools/check_docs.py
python3 tools/gen_seed.py

# اعتبارسنجی SQL
python3 -m venv /tmp/venv && /tmp/venv/bin/pip install pglast
/tmp/venv/bin/python -c "
import pglast, pathlib
for f in pathlib.Path('database').rglob('*.sql'):
    pglast.parse_sql(f.read_text(encoding='utf-8')); print('✓', f)
"
```

## قاعده
هر تغییر در مستندات یا اسکیما، پیش از commit باید `check_docs.py` را سبز کند.
