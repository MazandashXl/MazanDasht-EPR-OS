# Frontend — Vue 3 + TypeScript + Electron

```
frontend/
├─ apps/
│  ├─ desktop/      Electron (Win10/11 + بیلد جداگانه ES2019 برای Win7)
│  ├─ web/          وب‌اپ LAN
│  └─ mobile/       PWA (تبلت/موبایل)
├─ packages/
│  ├─ ui/           سیستم طراحی، کامپوننت‌های مشترک
│  ├─ core/         API client، مدل‌ها، تاریخ شمسی، قالب ارز
│  └─ offline/      SQLite، صف همگام‌سازی، حل تعارض
└─ tests/           Playwright
```

## اصول
- RTL بومی؛ اعداد فارسی در نمایش، لاتین در ورودی فنی.
- فرم اصلی بدون اسکرول در ۱۰۲۴×۷۶۸ ([ux-guidelines](../docs/ux/ux-guidelines.md)).
- دکمه `⊕` در مرکز هدر، همه‌جا ([quick-create](../docs/ux/quick-create.md)).
- محاسبات نمایشی زنده، اما منبع حقیقت سرور است.

## بیلد
```bash
npm ci
npm run build:web
npm run build:desktop        # Electron مدرن
npm run build:desktop-win7   # Electron 22 + target es2019
```
