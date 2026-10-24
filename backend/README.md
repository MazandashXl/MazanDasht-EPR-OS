# Backend — .NET 8 (C#)

ساختار برنامه‌ریزی‌شده (مرجع: [docs/architecture/technical-architecture.md](../docs/architecture/technical-architecture.md)):

```
backend/
├─ MazanDasht.Domain/          موجودیت‌ها، Value Object، فرمول‌ها، رویداد دامنه
├─ MazanDasht.Application/     Command/Query، اعتبارسنجی، Posting، Workflow
├─ MazanDasht.Infrastructure/  EF Core، Dapper، فایل، چاپ، دستگاه، همگام‌سازی
├─ MazanDasht.Api/             Endpoint، Middleware، Auth، OpenAPI
├─ MazanDasht.Jobs/            کارهای زمان‌بندی‌شده
└─ tests/
   ├─ Domain.Tests/
   ├─ Application.Tests/
   └─ Integration.Tests/
```

## مرز ماژول (اجباری)
هر ماژول `Entities/`, `Commands/`, `Queries/`, `Posting/`, `Permissions.cs`, `ModuleRegistration.cs` دارد.
دسترسی به DbContext ماژول دیگر ممنوع است؛ ارتباط فقط با Interface یا رویداد.

## قاعده طلایی
هیچ سند عملیاتی بدون سند حسابداری متوازن ثبت نمی‌شود ([VIS-01](../docs/00-foundations/vision.md)).

## اجرای تست
```bash
dotnet test
```
آزمون‌های طلایی: [docs/00-foundations/test-plan.md](../docs/00-foundations/test-plan.md)
