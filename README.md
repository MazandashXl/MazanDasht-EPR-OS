# MazanDasht EPR OS

**Intelligent Citrus Sorting & Financial Operating System**

سامانه یکپارچه عملیاتی، مالی و هوش تجاری برای صنعت سورت و بسته‌بندی مرکبات؛ ساخته‌شده بر پایه فرآیندهای واقعی مازندشت: باسکول، افت بار، سبد، سردخانه، کارتن، صافی مشتری و تسویه بارفروشان.

[![Docs](https://img.shields.io/badge/docs-v1.0--draft-blue)](docs/README.md)
[![Status](https://img.shields.io/badge/phase-architecture-orange)]()

## این چیست؟

| لایه | توضیح |
|---|---|
| **ERP تخصصی** | خرید، فروش، باسکول، سورت، بسته‌بندی، انبار، سردخانه، صادرات |
| **هسته مالی** | حسابداری دوبل کامل، ارزی، مرکز هزینه، باغ، سردخانه، شعبه |
| **اتوماسیون اسناد** | Import Studio برای اکسل و صورتحساب بانکی با تشخیص خودکار و حذف تکراری |
| **BI** | داشبورد ۳۰ روزه، سود هر تن/مشتری/محصول/سردخانه/باغ (Drill-down تا سند) |
| **چندسکویی** | Windows، شبکه داخلی بدون اینترنت، Android/iOS، آفلاین |

## شروع سریع مطالعه

1. [نقشه اسناد و قراردادها](docs/README.md)
2. [چشم‌انداز و اصول](docs/00-foundations/vision.md)
3. [معماری فنی](docs/architecture/technical-architecture.md)
4. [موتور حسابداری](docs/accounting/accounting-engine.md)
5. [باسکول](docs/modules/weighbridge.md) · [فروش و صافی](docs/modules/sales.md) · [Import Studio](docs/modules/import-studio.md)
6. [سناریوهای عملیاتی مازندشت](docs/scenarios/mazandasht-operations.md)

## ساختار مخزن

```
docs/          سند معماری نسخه ۱.۰ (منبع حقیقت)
database/      DDL، مایگریشن، داده نمونه
backend/       .NET 8 — Domain / Application / Infrastructure / API
frontend/      Vue 3 + Electron — کلاینت دسکتاپ و وب
api/           قرارداد OpenAPI
ui-ux/         توکن‌های طراحی، آیکون، پروتوتایپ
installer/     بسته نصب، اسکریپت راه‌اندازی سرور
manuals/       راهنمای کاربر و Help Center
tools/         اسکریپت‌های ساخت سند و ابزار توسعه
```

## وضعیت

نسخه فعلی: **سند معماری ۱.۰ (Draft)** — کدنویسی پس از تأیید هر ماژول آغاز می‌شود.

| سنجه | مقدار |
|---|---|
| اسناد | ۵۸ فایل · ≈ ۴۸٬۵۰۰ واژه · ≈ ۱۹۰ صفحه |
| شناسه‌های تعریف‌شده | ۱۰۱ نیازمندی · ۱۲۵ قاعده کسب‌وکار · ۳۲ سند خودکار · ۹۵ گزارش |
| داده اجرایی | `database/schema.sql` + seed (۱۳۶ حساب، ۱۶ نقش) + ۸ ویو |
| قرارداد API | `api/openapi.yaml` (OpenAPI 3.1) |
| تصمیم‌های معماری | ۸ ADR |

### بررسی سلامت مستندات

```bash
python3 tools/check_docs.py     # پیوندهای شکسته، شناسه‌های تکراری، بخش پذیرش، آمار
python3 tools/gen_seed.py       # تولید seed حساب‌ها و نقش‌ها
```

## مجوز

Proprietary — MazanDasht. All rights reserved.
