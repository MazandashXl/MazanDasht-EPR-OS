# نصب و استقرار

| پوشه | محتوا |
|---|---|
| `windows/` | اسکریپت PowerShell نصب سرویس، PostgreSQL، گواهی |
| `linux/` | اسکریپت systemd، Nginx، بکاپ |
| `offline-bundle/` | بسته نصب بدون اینترنت |
| `upgrade/` | اسکریپت ارتقا و بازگشت |

مرجع: [docs/deployment/install-backup.md](../docs/deployment/install-backup.md)

## چک‌لیست نصب
1. پیش‌نیاز سخت‌افزاری و OS
2. PostgreSQL + تنظیمات
3. اجرای `database/schema.sql` و seed
4. سرویس API + Reverse Proxy + TLS
5. Job Scheduler
6. آزمون دود: قبض → فاکتور → سند → گزارش
7. بکاپ خودکار و آزمون بازیابی
