# سند معماری MazanDasht EPR OS — نسخه ۱.۰

**Intelligent Citrus Sorting & Financial Operating System**
سامانه یکپارچه صنعت سورت و بسته‌بندی مرکبات + حسابداری مالی + عملیات + هوش تجاری + اتوماسیون اسناد

> این پوشه «منبع حقیقت» (Single Source of Truth) پروژه است. کد، دیتابیس، API و رابط کاربری همه از این اسناد مشتق می‌شوند.
> قاعده: **هر چیزی که در کد ساخته می‌شود، باید شناسه‌ای در این اسناد داشته باشد؛ و هر شناسه‌ای که در این اسناد هست، باید در کد قابل ردیابی باشد.**

---

## ۱. وضعیت نسخه

| مورد | مقدار |
|---|---|
| نسخه سند | `1.0.0-draft` |
| تاریخ شروع | ۱۴۰۴/۰۸/۰۲ (2026-10-24) |
| مخاطب | هیئت معماری، تیم توسعه، حسابرس مالی، مدیریت مازندشت |
| زبان | فارسی (RTL) + اصطلاحات فنی انگلیسی |
| واحد پول پایه | ریال ایران (IRR) — نمایش پیش‌فرض: تومان |
| تقویم عملیاتی | هجری شمسی (Jalali) — ذخیره‌سازی استاندارد UTC |
| سال مالی | ۱ فروردین تا ۲۹/۳۰ اسفند |
| دامنه نسخه ۱.۰ | هسته داده، حسابداری، بانک و Import Studio، باسکول، انبار، خرید، فروش، صافی مشتری، BI، گزارش، چاپ، امنیت |

---

## ۲. نقشه اسناد و ترتیب مطالعه

خواندن اسناد به ترتیب زیر توصیه می‌شود. هر سند مستقل قابل خواندن است، اما ارجاع‌های `[](#)` بین اسناد برقرار است.

### جلد اول — بنیان‌ها

| # | سند | مسیر | مسئول تدوین (نقش مجازی) |
|---|---|---|---|
| ۱ | چشم‌انداز و اصول | [00-foundations/vision.md](00-foundations/vision.md) | مدیر محصول |
| ۲ | واژه‌نامه و اصطلاحات صنعت | [00-foundations/glossary.md](00-foundations/glossary.md) | متخصص صنعت مرکبات |
| ۳ | تیم، حاکمیت و فرآیند تصمیم | [00-foundations/team-governance.md](00-foundations/team-governance.md) | مدیر محصول + معمار ERP |
| ۴ | نیازمندی‌ها و ردیابی | [00-foundations/requirements.md](00-foundations/requirements.md) | مدیر محصول |
| ۵ | قواعد کسب‌وکار (BR) | [00-foundations/business-rules.md](00-foundations/business-rules.md) | معمار ERP |
| ۶ | اصطلاحات و قواعد داده (Data Contract) | [00-foundations/data-conventions.md](00-foundations/data-conventions.md) | معمار ERP |

### جلد دوم — معماری

| # | سند | مسیر |
|---|---|---|
| ۷ | معماری فنی و استقرار | [architecture/technical-architecture.md](architecture/technical-architecture.md) |
| ۸ | هسته داده (Data Core Engine) | [architecture/data-core.md](architecture/data-core.md) |
| ۹ | موتور گردش کار و رویدادها | [architecture/workflow-events.md](architecture/workflow-events.md) |
| ۱۰ | مجوزها و امنیت | [security/permissions.md](security/permissions.md) |
| ۱۱ | شبکه، آفلاین و همگام‌سازی | [deployment/networking-offline.md](deployment/networking-offline.md) |
| ۱۲ | استقرار، نصب و پشتیبان‌گیری | [deployment/install-backup.md](deployment/install-backup.md) |
| ۱۳ | تصمیم‌های معماری (ADR) | [adr/](adr/README.md) |

### جلد سوم — موتور مالی

| # | سند | مسیر |
|---|---|---|
| ۱۴ | موتور حسابداری دوبل | [accounting/accounting-engine.md](accounting/accounting-engine.md) |
| ۱۵ | ساختار حساب‌ها (کدینگ کامل) | [accounting/chart-of-accounts.md](accounting/chart-of-accounts.md) |
| ۱۶ | سناریوهای سند خودکار | [accounting/posting-scenarios.md](accounting/posting-scenarios.md) |
| ۱۷ | ارز، تورم و چندارزی | [accounting/currency.md](accounting/currency.md) |
| ۱۸ | بستن دوره و سال مالی | [accounting/period-close.md](accounting/period-close.md) |
| ۱۹ | خزانه، بانک، چک | [modules/treasury-bank-cheque.md](modules/treasury-bank-cheque.md) |
| ۲۰ | Import Studio | [modules/import-studio.md](modules/import-studio.md) |

### جلد چهارم — عملیات

| # | سند | مسیر |
|---|---|---|
| ۲۱ | باسکول (قلب سیستم) | [modules/weighbridge.md](modules/weighbridge.md) |
| ۲۲ | خرید | [modules/purchasing.md](modules/purchasing.md) |
| ۲۳ | فروش و صافی مشتری | [modules/sales.md](modules/sales.md) |
| ۲۴ | انبار و سردخانه | [modules/inventory-warehouse.md](modules/inventory-warehouse.md) |
| ۲۵ | تولید، سورت و بسته‌بندی | [modules/production-packaging.md](modules/production-packaging.md) |
| ۲۶ | مشتریان و CRM | [modules/crm.md](modules/crm.md) |
| ۲۷ | پرسنل و حقوق | [modules/hr-payroll.md](modules/hr-payroll.md) |
| ۲۸ | دارایی ثابت و نگهداری | [modules/fixed-assets.md](modules/fixed-assets.md) |

### جلد پنجم — خروجی‌ها و تجربه

| # | سند | مسیر |
|---|---|---|
| ۲۹ | هوش تجاری و KPI | [modules/bi-dashboard.md](modules/bi-dashboard.md) |
| ۳۰ | کاتالوگ گزارش‌ها | [reports/reports-catalog.md](reports/reports-catalog.md) |
| ۳۱ | قالب‌های چاپ و اسناد | [print/print-templates.md](print/print-templates.md) |
| ۳۲ | اصول UX و طراحی صفحات | [ux/ux-guidelines.md](ux/ux-guidelines.md) |
| ۳۳ | دکمه طلایی «ایجاد سریع» | [ux/quick-create.md](ux/quick-create.md) |
| ۳۴ | سطوح دسترسی و ماتریس نقش | [security/roles-matrix.md](security/roles-matrix.md) |
| ۳۵ | راهنمای هوشمند و Help Center | [ux/help-center.md](ux/help-center.md) |

### جلد ششم — اجرا

| # | سند | مسیر |
|---|---|---|
| ۳۶ | مدل داده کامل (ERD + DDL) | [data/README.md](data/README.md) |
| ۳۷ | کاتالوگ API | [api/README.md](api/README.md) |
| ۳۸ | سناریوهای عملیاتی مازندشت | [scenarios/mazandasht-operations.md](scenarios/mazandasht-operations.md) |
| ۳۹ | نقشه توسعه و فازبندی | [00-foundations/roadmap.md](00-foundations/roadmap.md) |
| ۴۰ | طرح آزمون پذیرش (UAT) | [00-foundations/test-plan.md](00-foundations/test-plan.md) |

---

## ۳. قراردادهای مشترک اسناد

### ۳.۱ پیشوند شناسه‌ها

| پیشوند | معنا | مثال | محل تعریف |
|---|---|---|---|
| `VIS-` | اصل چشم‌انداز | `VIS-07` | vision.md |
| `REQ-F-` | نیازمندی کارکردی | `REQ-F-112` | requirements.md |
| `REQ-N-` | نیازمندی غیرکارکردی | `REQ-N-014` | requirements.md |
| `BR-` | قاعده کسب‌وکار | `BR-214` | business-rules.md |
| `ENT-` | موجودیت داده | `ENT-WB-003` | data/ |
| `EVT-` | رویداد دامنه | `EVT-SAL-POSTED` | workflow-events.md |
| `JE-` | سناریوی سند خودکار | `JE-SAL-001` | posting-scenarios.md |
| `RPT-` | گزارش | `RPT-FIN-004` | reports-catalog.md |
| `KPI-` | شاخص کلیدی | `KPI-SAL-003` | bi-dashboard.md |
| `PRM-` | مجوز | `PRM.sales.invoice.post` | permissions.md |
| `SCR-` | صفحه | `SCR-WB-TICKET` | ux/ |
| `IMP-` | قاعده واردسازی | `IMP-BANK-MELLAT` | import-studio.md |
| `ADR-` | تصمیم معماری | `ADR-0003` | adr/ |

### ۳.۲ پیشوند جداول دیتابیس

| پیشوند | حوزه | نمونه |
|---|---|---|
| `sys_` | سیستم، امنیت، تنظیمات | `sys_user`, `sys_audit_log` |
| `core_` | هسته مشترک (اشخاص، کالا، واحدها، ارز) | `core_party`, `core_item` |
| `fin_` | حسابداری، خزانه، بانک | `fin_voucher`, `fin_bank_statement` |
| `wb_` | باسکول | `wb_ticket`, `wb_weighing` |
| `pur_` | خرید | `pur_order`, `pur_invoice` |
| `sal_` | فروش | `sal_invoice`, `sal_deduction` |
| `inv_` | انبار، سردخانه، موجودی | `inv_stock_move`, `inv_lot` |
| `prd_` | تولید، سورت، بسته‌بندی | `prd_batch`, `prd_pack_run` |
| `crm_` | مشتریان، باشگاه، پیگیری | `crm_profile`, `crm_interaction` |
| `hr_` | پرسنل و حقوق | `hr_employee`, `hr_payroll_run` |
| `ast_` | دارایی ثابت | `ast_asset` |
| `imp_` | Import Studio | `imp_batch`, `imp_template` |
| `bi_` | مarts و شاخص‌ها | `bi_fact_sales` |
| `doc_` | فایل، ضمیمه، چاپ | `doc_attachment` |

### ۳.۳ قرارداد نام‌گذاری ستون‌ها

| الگو | معنا |
|---|---|
| `id` | کلید اصلی `uuid` (v7، مرتب بر زمان) |
| `code` | کد یکتا و قابل نمایش به کاربر (مثل `CUS-000123`) |
| `*_id` | کلید خارجی |
| `*_at` | زمان رخداد (`timestamptz`, UTC) |
| `business_date` | تاریخ کاری شمسی معادل (`date`) برای گزارش‌گیری |
| `status` | وضعیت چرخه عمر (enum متنی) |
| `amount_base` | مبلغ به ارز پایه |
| `qty`, `weight_kg` | مقدار عددی با ۳ رقم اعشار |
| `is_*` / `has_*` | پرچم بولی |
| `created_*`, `updated_*`, `deleted_at` | ردگیری و حذف نرم |

### ۳.۴ قواعد نوشتاری

1. **مبلغ‌ها** همیشه با ذکر واحد: `۱۲٬۵۰۰٬۰۰۰ ریال (۱٬۲۵۰٬۰۰۰ تومان)`.
2. **وزن‌ها** همیشه کیلوگرم با ۳ اعشار: `۱۸٬۴۵۰٫۵۰۰ kg`.
3. **ارقام** در متن فارسی با ارقام فارسی، در کد و API با ارقام لاتین.
4. هر سند باید بخش «**پذیرش**» داشته باشد: معیارهایی که می‌توان با آن گفت ماژول درست ساخته شده است.
5. هر تغییر روی سند، در [CHANGELOG](../CHANGELOG.md) و در جدول «تاریخچه تصمیم» ثبت می‌شود.

---

## ۴. اصول غیرقابل مذاکره (خلاصه)

| کد | اصل |
|---|---|
| VIS-01 | هیچ سندی بدون سند حسابداری متوازن ثبت نمی‌شود. |
| VIS-02 | هر رویداد عملیاتی یک شناسه یکتا دارد و از هسته داده عبور می‌کند. |
| VIS-03 | سند ثبت‌شده (Posted) تغییر یا حذف نمی‌شود؛ فقط سند اصلاحی/برگشتی. |
| VIS-04 | کاربر نباید برای ثبت کار روزانه از فرم فعلی خارج شود (Flyout / Quick Create). |
| VIS-05 | سیستم در قطعی اینترنت کامل کار می‌کند؛ آفلاین «حالت» است، نه «نسخه». |
| VIS-06 | هر عدد در داشبورد باید تا سند اولیه قابل Drill-down باشد. |
| VIS-07 | هیچ ورودی دستی بدون اعتبارسنجی، پیش‌نمایش و امکان بازگشت (Undo قبل از ثبت) انجام نمی‌شود. |
| VIS-08 | هر عملیات حساس، ردپای تغییر (Before/After) و امضای دیجیتال دارد. |
| VIS-09 | رابط کاربری به زبان کار روزمره است، نه زبان دفترداری. |
| VIS-10 | تفکیک وظایف: ثبت‌کننده ≠ تأییدکننده ≠ پرداخت‌کننده. |

---

## ۵. نحوه استفاده تیم توسعه

1. **قبل از کدنویسی هر ماژول**، سند همان ماژول کامل و «تأییدشده» (Status: Approved) شود.
2. برای هر موجودیت، DDL از [data/](data/README.md) و برای هر عملیات، endpoint از [api/](api/README.md) ساخته می‌شود.
3. هر PR باید ارجاع به شناسه‌های `REQ-`/`BR-`/`JE-` داشته باشد.
4. تغییر در ساختار حساب‌ها یا قواعد سند خودکار، نیازمند تأیید **حسابرس مالی ارشد** و ثبت `ADR` است.
5. تغییر در فرمول وزن/افت/سبد، نیازمند تأیید **متخصص صنعت مرکبات** است.

---

## ۶. وضعیت تدوین

| جلد | اسناد | وضعیت |
|---|---|---|
| اول — بنیان‌ها | vision, glossary, team-governance, requirements, business-rules, data-conventions, roadmap, test-plan | ✅ پایه تدوین شد |
| دوم — معماری | technical-architecture, data-core, workflow-events, networking-offline, install-backup | ✅ پایه |
| سوم — موتور مالی | accounting-engine, chart-of-accounts, posting-scenarios, currency, period-close | ✅ پایه |
| سوم — خزانه | treasury-bank-cheque, import-studio | ✅ پایه |
| چهارم — عملیات | weighbridge, purchasing, sales, inventory-warehouse, production-packaging, crm, hr-payroll, fixed-assets | ✅ پایه |
| پنجم — خروجی و تجربه | bi-dashboard, reports-catalog, print-templates, ux-guidelines, quick-create, help-center, permissions, roles-matrix | ✅ پایه |
| ششم — اجرا | data (ERD + فهرست جدول‌ها), api (کاتالوگ), scenarios, adr (۸ تصمیم) | ✅ پایه |
| داده اجرایی | `database/schema.sql` + seed + views، `api/openapi.yaml` | ✅ تولیدشده |

نمادها: ✅ پایه تدوین شد · 🚧 در حال تدوین · ⏳ در نوبت

### ۶.۱ وضعیت فعلی در یک نگاه

| سنجه | مقدار |
|---|---|
| فایل مستند markdown | ۵۸ |
| واژه | ≈ ۴۸٬۵۰۰ |
| تخمین حجم | ≈ ۱۹۰ صفحه (۲۵۰ واژه/صفحه) |
| سطر جدول | ≈ ۳٬۵۰۰ |
| نیازمندی دارای شناسه | ۱۰۱ |
| قاعده کسب‌وکار | ۱۲۵ |
| سناریوی سند خودکار | ۳۲ |
| KPI | ۲۴ |
| گزارش تعریف‌شده | ۹۵ |
| جدول دیتابیس طراحی‌شده | ۹۰+ (۷۰ در DDL پایه) |
| بررسی سلامت مستندات | `python3 tools/check_docs.py` |

### ۶.۲ آنچه هنوز باید تکمیل شود (پیش از کدنویسی هر ماژول)

| # | کار | مالک | چرا |
|---|---|---|---|
| ۱ | تأیید ساختار حساب‌ها با حسابرس واقعی مازندشت | حسابرس ارشد | تغییر آن پس از کدنویسی گران است |
| ۲ | آزمون سناریوهای §۱ با داده واقعی یک روز | متخصص صنعت | کشف شکاف فرآیند |
| ۳ | پروتوتایپ قابل کلیک صفحه باسکول و فاکتور | UX | تغییر ارزان‌تر از کد |
| ۴ | تکمیل `openapi.yaml` برای همه ماژول‌ها | معمار | قرارداد فرانت/بک |
| ۵ | seed کامل حساب‌های تفصیلی و تنظیمات | حسابدار | آماده‌سازی نصب |
| ۶ | Help Center: یک مقاله کامل نمونه برای هر نقش | مدیر محصول | الگوی نگارش |

> فهرست بالا «بدهی مستندسازی» است؛ هر مورد که بسته نشود، در فاز کدنویسی به «بدهی طراحی» تبدیل می‌شود.
