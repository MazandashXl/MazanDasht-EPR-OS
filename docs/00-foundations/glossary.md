# واژه‌نامه و اصطلاحات صنعت مرکبات

سند مرجع: `MD-GLS-001` · نسخه ۱.۰ · مالک: متخصص صنعت مرکبات · هم‌نویسنده: حسابرس مالی

هدف: یک زبان مشترک. هر برچسب UI، نام ستون دیتابیس و هر گزارش، از این واژه‌نامه مشتق می‌شود. اگر واژه‌ای اینجا نیست، نباید در محصول ظاهر شود.

---

## ۱. اصطلاحات عملیاتی (باسکول و بار)

| اصطلاح فارسی | معادل انگلیسی | تعریف دقیق | نماد/ستون | واحد |
|---|---|---|---|---|
| باسکول | Weighbridge / Scale | سکوی توزین کامیون؛ همچنین نام کلی فرآیند توزین و صدور قبض | `wb_*` | — |
| قبض باسکول | Weigh Ticket | سند یکتای ورود/خروج بار با وزن، تاریخ، راننده، باغ/مشتری، QR | `wb_ticket` | — |
| وزن اول (پر) | Gross / Loaded Weight | وزن کامیون همراه بار | `gross_weight_kg` | kg |
| وزن دوم (خالی) | Tare / Empty Weight | وزن کامیون بدون بار | `tare_weight_kg` | kg |
| وزن بار | Net Vehicle Weight | وزن اول − وزن دوم | `vehicle_net_kg` | kg |
| وزن سبد | Basket Tare | وزن ظرف؛ تعداد × وزن استاندارد نوع سبد | `basket_tare_kg` | kg |
| افت بار | Shrinkage / Loss % | کسر توافقی بابت خشکیدگی، ضایعات مسیر، خاک و خسارت | `waste_pct`, `waste_kg` | % / kg |
| وزن خالص | Net Weight | وزن قابل معامله (فرمول بخش ۲) | `net_weight_kg` | kg |
| سبد | Basket / Crate | ظرف حمل مرکبات با وزن استاندارد مشخص | `core_container_type` | — |
| سبد قرمز/زرد/مشکی | Red/Yellow/Black Basket | انواع سبد با وزن استاندارد متفاوت | — | kg |
| توزین دو مرحله‌ای | Two-pass weighing | وزن پر و خالی در دو زمان؛ برای کرایه و کنترل | `wb_weighing` | — |
| توزین یک‌مرحله‌ای | Single-pass | فقط وزن پر؛ وزن خالی از کارت مشخصات کامیون | — | — |
| بارنامه | Waybill | سند حمل بار از مبدأ تا مقصد | `sal_shipment` | — |
| نوبت باسکول | Weight Queue | صف انتظار کامیون، صادرشده از دروازه | `wb_queue` | — |
| دروازه | Gate | نقطه ورود/خروج فیزیکی؛ ثبت پلاک و نوبت | `wb_gate_log` | — |
| پلاک | Plate No | شماره پلاک خودرو، نرمال‌شده (بدون فاصله/حروف فارسی) | `vehicle.plate_no` | — |
| راننده | Driver | شخص حامل بار؛ طرف حساب کرایه در برخی قراردادها | `core_party` نقش `DRIVER` | — |
| باسکول‌چی | Scale Operator | کاربر مجاز توزین و صدور قبض | نقش `WB_OPERATOR` | — |
| تالار | Trading Floor / Market | محل معامله بار (میدان میوه) | `crm_channel = MARKET` | — |
| بارفروش | Market Trader (Bārfurush) | خریدار عمده مستقر در میدان؛ معمولاً با صافی و تسویه مدت‌دار | نقش `MARKET_TRADER` | — |
| باغدار | Grower | تأمین‌کننده میوه از باغ؛ طرف حساب خرید | نقش `GROWER` | — |
| عمده‌فروش | Wholesaler | خریدار حجم بالا، اغلب بی‌واسطه | نقش `WHOLESALER` | — |
| صادرکننده | Exporter | خریدار خارجی/واسطه صادرات با الزامات بسته‌بندی و مدارک | نقش `EXPORTER` | — |
| دلال/واسطه | Broker | واسطه معامله؛ کمیسیون‌گیر | نقش `BROKER` | — |
| بارگری | Loading/Unloading Labor | دستمزد تخلیه/بارگیری؛ کسور فاکتور | `LOADING` | ریال |
| صافی | Deduction / Purity Adjustment | مجموعه کسورات توافقی از مبلغ فاکتور (درصدی یا مبلغی) | `sal_deduction` | % / ریال |
| کمیسیون | Commission | درصدی از مبلغ فروش برای واسطه/بارفروش | `COMMISSION` | % |
| کرایه | Freight | هزینه حمل؛ می‌تواند بر عهده خریدار یا فروشنده باشد | `FREIGHT` | ریال |
| کارتن | Carton | بسته‌بندی نهایی؛ با ابعاد، وزن و ظرفیت مشخص | `core_item` نوع `CARTON` | — |
| پالت | Pallet | واحد بارگیری کارتن‌ها؛ با تعداد کارتن استاندارد | `pallet` | — |
| شرینک | Shrink Wrap | بسته‌بندی پلاستیکی دور پالت | `PACK_MATERIAL` | — |
| سورت | Sorting / Grading | تفکیک میوه بر اساس درجه، اندازه، رنگ و سلامت | `prd_sort_run` | — |
| درجه | Grade | طبقه‌بندی کیفی (درجه یک، دو، صنعتی) | `grade_code` | — |
| کالیبر | Caliber / Size | اندازه میوه (مثلاً ۶۰–۶۵ mm یا شماره کالیبر) | `caliber` | mm |
| بسته‌بندی | Packing | قرار دادن میوه در کارتن/سبد خرده‌فروشی | `prd_pack_run` | — |
| ضایعات | Waste / Reject | میوه غیرقابل فروش یا دورریز در سورت/بسته‌بندی | `waste_kg`, `waste_pct` | kg / % |
| افت سورت | Sort Yield Loss | کاهش وزن بین ورود و خروج خط سورت | `yield_loss_pct` | % |
| راندمان | Yield / Recovery | وزن خروجی سالم ÷ وزن ورودی | `yield_pct` | % |
| سردخانه | Cold Storage | اتاق سرد با دما و رطوبت کنترل‌شده | `inv_location` نوع `COLD_ROOM` | — |
| اتاق | Room / Chamber | واحد داخل سردخانه؛ دارای ظرفیت و دما | `cold_room` | — |
| دمای نگهداشت | Holding Temperature | دمای هدف برای هر رقم مرکبات (مثلاً ۵–۸ °C نارنگی) | `target_temp_c` | °C |
| لات | Lot / Batch | گروه میوه با منشأ یک قبض باسکول/باغ و تاریخ | `inv_lot` | — |
| شماره لات | Lot No | شناسه قابل چاپ روی کارتن برای ردیابی | `lot_no` | — |
| موجودی وزنی | Weight-based Stock | موجودی بر حسب کیلوگرم برای میوه فله | `qty_kg` | kg |
| موجودی شمارشی | Count-based Stock | موجودی بر حسب عدد (کارتن، سبد، پالت) | `qty` | عدد |
| مغایرت | Discrepancy | اختلاف بین شمارش فیزیکی و دفتری | `inv_count_line.diff` | — |
| حمل | Transport | فرآیند ارسال بار به خریدار | `sal_shipment` | — |
| تسویه | Settlement | فرآیند بستن حساب فاکتور با نقد/چک/حواله | `fin_settlement` | — |
| وصول | Collection | دریافت وجه مطالبات | `fin_receipt` | — |
| برگشت از فروش | Sales Return | بازگشت بار توسط خریدار با قبض باسکول برگشتی | `sal_return` | — |
| نرخ/فی | Unit Price | قیمت هر کیلو یا هر کارتن | `unit_price` | ریال |

---

## ۲. فرمول‌های رسمی (مرجع واحد)

همه فرمول‌ها در `sys_formula` با کد، نسخه و تاریخ اعتبار ذخیره می‌شوند. تغییر فرمول، اسناد گذشته را بازنویسی نمی‌کند.

### F-01 وزن خالص (خرید با سبد)

```
vehicle_net_kg = gross_weight_kg − tare_weight_kg
basket_tare_kg = Σ (basket_count_i × basket_type_weight_i)
waste_kg       = (vehicle_net_kg − basket_tare_kg) × waste_pct / 100
net_weight_kg  = vehicle_net_kg − basket_tare_kg − waste_kg
```

### F-02 وزن خالص (خرید بدون سبد / فله)

```
net_weight_kg = (gross_weight_kg − tare_weight_kg) × (1 − waste_pct/100)
```

### F-03 افت بار با مبناهای مختلف

| مبنا | فرمول |
|---|---|
| بر وزن بار (`GROSS_NET`) | `waste_kg = vehicle_net_kg × pct/100` |
| بر وزن پس از کسر سبد (`AFTER_BASKET`) | پیش‌فرض F-01 |
| مبلغ ثابت به کیلو (`FIXED_PER_KG`) | `waste_kg = pct` (پارامتر = کیلوگرم) |
| پله‌ای (`TIERED`) | نرخ بر اساس بازه وزنی/فصلی از جدول `pur_loss_tier` |

### F-04 مبلغ ردیف فاکتور

```
line_amount = net_weight_kg × unit_price
```

### F-05 صافی مشتری (کسورات)

```
gross_amount = Σ line_amount
deductions   = Σ (pct_based: gross_amount × pct/100) + Σ (fixed amounts)
net_payable  = gross_amount − deductions + additions (if any)
```

قاعده: کسورات نوع `PCT` روی `gross_amount` (نه روی مبلغ پس از کسور دیگر) محاسبه می‌شوند؛ ترتیب اعمال در `sal_deduction.sequence` تعیین می‌شود.

### F-06 بهای تمام‌شده محموله (Cost per Lot)

```
lot_cost = purchase_amount
         + inbound_freight + loading + sorting_labor + packing_material
         + cold_storage_cost_allocated + waste_cost_allocated
cost_per_kg = lot_cost / net_saleable_kg
```

### F-07 سود هر تن

```
profit_per_ton = (net_sales − cogs − direct_costs) / (sold_kg / 1000)
```

### F-08 راندمان سورت

```
yield_pct = packed_kg / sorted_input_kg × 100
waste_pct = waste_kg  / sorted_input_kg × 100
```

قاعده پذیرش: `yield_pct + waste_pct + rework_pct ≈ ۱۰۰٪` با تلورانس ۰٫۵٪؛ در غیر این صورت قبض خط سورت «مشکوک» علامت می‌خورد.

---

## ۳. اصطلاحات مالی و حسابداری

| اصطلاح | معادل | تعریف در این سیستم |
|---|---|---|
| گروه حساب | Account Group | یکی از ۶ گروه: دارایی، بدهی، سرمایه، درآمد، هزینه، انتظامی |
| کل | General Ledger Account (Kol) | سطح ۲؛ کد ۴ رقمی (گروه + ۳ رقم) |
| معین | Subsidiary Account | سطح ۳؛ کد ۵ رقمی |
| تفصیلی | Detail Account | سطح ۴؛ کد ۹ رقمی؛ محل ثبت نهایی (مثلاً یک بانک/مشتری خاص) |
| شناور | Floating Account | حساب واسط که با تسویه بسته می‌شود (مثل «حساب‌های دریافتنی موقت») |
| مرکز هزینه | Cost Center | واحد مسئول هزینه (سردخانه، خط بسته‌بندی، حمل) |
| پروژه | Project | ابتکار یا قرارداد دارای بودجه |
| شعبه | Branch | واحد حقوقی/محلی مستقل گزارش‌دهی |
| باغ | Garden | مبدأ محصول؛ بعد تحلیلی خرید و سود |
| سردخانه | Cold Storage | بعد تحلیلی نگهداشت و سود |
| سند حسابداری | Journal Voucher | مجموعه خطوط بدهکار/بستانکار متوازن |
| سند خودکار | Auto Posting | سندی که موتور Posting از رویداد می‌سازد |
| سند دستی | Manual Voucher | سند ثبت‌شده توسط حسابدار |
| سند برگشتی | Reversal | سند معکوس برای اصلاح، با ارجاع به سند اصلی |
| سند اصلاحی | Adjusting Entry | سند تعدیل با شرح دلیل و مجوز |
| دفتر روزنامه | Journal | فهرست زمانی اسناد |
| دفتر کل | General Ledger | گردش هر حساب کل |
| تراز آزمایشی ۴ ستونه | 4-column Trial Balance | بدهکار/بستانکار/مانده بدهکار/مانده بستانکار |
| تراز آزمایشی ۶ ستونه | 6-column Trial Balance | گردش بدهکار/بستانکار + مانده‌ها |
| ترازنامه | Balance Sheet | صورت وضعیت مالی |
| سود و زیان | P&L / Income Statement | صورت سود و زیان دوره |
| جریان نقدی | Cash Flow | گردش وجه نقد (عملیاتی/سرمایه‌ای/تأمین مالی) |
| بستن دوره | Period Close | قفل ماه؛ عدم امکان ثبت گذشته بدون مجوز بازگشایی |
| بستن سال | Year Close | انتقال مانده‌های موقت به سود انباشته |
| چک دریافتی | Incoming Cheque | چک از مشتری |
| چک پرداختی | Outgoing Cheque | چک به تأمین‌کننده |
| چک برگشتی | Bounced Cheque | چک وصول‌نشده؛ نیازمند سند برگشتی |
| حواله | Transfer / Remittance | انتقال بین حساب‌های بانکی |
| صورتحساب بانکی | Bank Statement | فایل/گزارش تراکنش بانک برای Import Studio |
| تطبیق بانکی | Reconciliation | مطابقت تراکنش بانک با اسناد داخلی |
| مانده صندوق | Cash Box Balance | موجودی نقدی خزانه |
| تنخواه | Petty Cash | صندوق هزینه‌های کوچک |
| مالیات بر ارزش افزوده | VAT | ۱۰٪ جاری (پارامتر سیستمی، قابل تغییر) |
| عوارض | Duties | عوارض صنفی/شهرداری قابل تنظیم |

---

## ۴. اصطلاحات فنی/سیستمی

| اصطلاح | معنا در این سیستم |
|---|---|
| هسته داده (Data Core) | تنها مسیر مجاز ورود/تغییر داده؛ شامل اعتبارسنجی، رویداد، حسابداری |
| رویداد دامنه (Domain Event) | رخداد ثبت‌شده‌ای مثل `sales.invoice.posted` که سایر ماژول‌ها را بیدار می‌کند |
| Outbox | جدول صف رویداد؛ تضمین «یک‌بار اجرا» همراه با تراکنش اصلی |
| Idempotency Key | کلید یکتا برای جلوگیری از ثبت تکراری در تکرار درخواست/همگام‌سازی |
| Dry-run | اجرای آزمایشی ورود داده بدون ثبت نهایی |
| Drill-down | رفتن از عدد تجمیعی به سند اولیه |
| Flyout | پنجره شناور کنار فرم بدون ترک صفحه |
| Quick Create (⊕) | دکمه طلایی ایجاد سریع در هدر |
| Template | الگوی نگاشت ستون‌های فایل ورودی به فیلدهای سیستم |
| Posting Rule | قاعده تبدیل رویداد به سند حسابداری |
| Dimension | بُعد تحلیلی سند (مرکز هزینه، باغ، سردخانه، پروژه...) |
| Snapshot | تصویر ثابت داده در زمان (مثل بهای تمام‌شده در لحظه فروش) |
| Soft Delete | حذف منطقی با `deleted_at`؛ داده حسابداری هرگز حذف فیزیکی نمی‌شود |
| Fiscal Year | سال مالی شمسی با کد `1404` |

---

## ۵. استانداردهای کدگذاری

| موجودیت | الگو | نمونه | توضیح |
|---|---|---|---|
| شخص (طرف حساب) | `CUS/GRO/SUP/DRV-######` | `CUS-000123` | پیشوند بر اساس نقش اصلی |
| کالا | `ITM-#####` | `ITM-01042` | — |
| باغ | `GRD-####` | `GRD-0031` | — |
| قبض باسکول | `YYMMDD-BR-####` | `1404-07-18-WB-0042` | تاریخ شمسی + شعبه + شماره روز |
| فاکتور فروش | `SYY-######` | `S14-002381` | `S` + سال + سری |
| فاکتور خرید | `PYY-######` | `P14-001902` | — |
| سند حسابداری | `YYMM-#####` | `140407-00891` | سال+ماه شمسی + شماره سری |
| چک | `CH-#####` | `CH-00182` | — |
| حواله انبار | `WH-YY-#####` | `WH-04-00231` | نوع حواله + سال + سری |
| لات | `LOT-YYMMDD-###` | `LOT-14040718-003` | تاریخ + شماره |
| کارتن/پالت | `CTN-#####` | `CTN-00231` | — |
| پرسنل | `EMP-####` | `EMP-0042` | — |

**قاعده:** کدها هرگز بازاستفاده نمی‌شوند؛ حتی اگر سند حذف/برگشت شود.

---

## ۶. مقادیر شمارشی استاندارد (Enums)

| Enum | مقادیر |
|---|---|
| `party_role` | `GROWER`, `SUPPLIER`, `MARKET_TRADER`, `WHOLESALER`, `EXPORTER`, `BROKER`, `DRIVER`, `EMPLOYEE`, `CUSTOMER_RETAIL` |
| `ticket_direction` | `IN` (ورود بار), `OUT` (خروج بار) |
| `ticket_status` | `DRAFT`, `WEIGHED`, `PRICED`, `APPROVED`, `POSTED`, `VOID` |
| `invoice_status` | `DRAFT`, `CONFIRMED`, `POSTED`, `PARTIALLY_SETTLED`, `SETTLED`, `VOID` |
| `payment_method` | `CASH`, `CHEQUE`, `TRANSFER`, `CARD`, `OFFSET`, `CREDIT_NOTE` |
| `deduction_type` | `PURITY` (صافی), `FREIGHT`, `COMMISSION`, `LOSS`, `PACKAGING`, `CARTON`, `LOADING`, `LABOR`, `OTHER` |
| `stock_move_type` | `IN_PURCHASE`, `IN_PRODUCTION`, `OUT_SALES`, `OUT_PRODUCTION`, `TRANSFER`, `ADJUST`, `RETURN_IN`, `RETURN_OUT` |
| `item_type` | `FRUIT`, `CARTON`, `BASKET`, `PALLET`, `PACK_MATERIAL`, `SERVICE`, `FUEL`, `SPARE` |
| `grade` | `A` (درجه یک), `B` (درجه دو), `C` (صنعتی), `WASTE` |
| `doc_status` | `DRAFT`, `PENDING_APPROVAL`, `APPROVED`, `POSTED`, `REVERSED` |

---

## ۷. پذیرش

- [ ] هر برچسب در UI با ستون «اصطلاح فارسی» این سند مطابق است (آزمون خودکار واژه‌نامه در CI).
- [ ] هیچ واژه انگلیسی خام در UI کاربر نهایی دیده نمی‌شود مگر اصطلاح فنی تثبیت‌شده (QR، KPI).
- [ ] همه فرمول‌های بخش ۲ به‌صورت تست واحد در `backend/tests/formulas` پیاده شده‌اند.
