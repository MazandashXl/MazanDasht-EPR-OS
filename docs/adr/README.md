# تصمیم‌های معماری (ADR)

هر تصمیم مهم که بعداً «چرا این‌طور شد؟» می‌سازد، یک ADR دارد.

| # | عنوان | وضعیت |
|---|---|---|
| [0001](0001-modular-monolith.md) | Modular Monolith به‌جای میکروسرویس | Accepted |
| [0002](0002-postgres-and-sqlite.md) | PostgreSQL اصلی + SQLite برای آفلاین | Accepted |
| [0003](0003-windows-7-strategy.md) | راهبرد Windows 7 | Accepted |
| [0004](0004-offline-first-sync.md) | آفلاین-اول و همگام‌سازی | Accepted |
| [0005](0005-double-entry-enforcement.md) | الزام دوبل در سطح دیتابیس | Accepted |
| [0006](0006-jalali-calendar.md) | تقویم شمسی و ذخیره‌سازی UTC | Accepted |
| [0007](0007-waste-valuation.md) | ارزش‌گذاری ضایعات در نسخه ۱.۰ | Proposed |
| [0008](0008-json-vs-relational-dimensions.md) | ابعاد تحلیلی رابطه‌ای به‌جای JSON | Accepted |

## قالب

```markdown
# ADR-000X — عنوان
- تاریخ / وضعیت (Proposed | Accepted | Superseded | Rejected)
- تصمیم‌گیرندگان / مرتبط (REQ-، BR-)

## زمینه
## گزینه‌ها
## تصمیم
## پیامدها (مثبت / منفی / نیازمند بازبینی)
```
