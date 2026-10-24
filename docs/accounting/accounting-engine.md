# موتور حسابداری دوبل

سند مرجع: `MD-ACC-001` · نسخه ۱.۰ · مالک: حسابرس مالی ارشد · بازبین: معمار ERP

> **قاعده بنیادین:** یک عملیات، یک رویداد، یک سند. سند ثبت‌شده مقدس است: تغییر نمی‌کند، حذف نمی‌شود، فقط برگشت می‌خورد.

---

## ۱. مدل داده حسابداری

### ۱.۱ نمودار موجودیت‌ها

```
core_fiscal_year ──< core_fiscal_period ──< fin_voucher ──< fin_voucher_line >── fin_account
                                                │                  │
                                                │                  ├──< fin_line_dimension >── fin_dimension_value
                                                │                  │
                                                ├──< fin_voucher_link (اصل ↔ برگشت ↔ اصلاحی)
                                                ├── source_entity / source_id  (سند خودکار)
                                                └── hash_prev / hash_current

fin_account ──< fin_account (درخت ۴ سطحی)
fin_account_balance (ماهانه، Materialized، بازسازی‌پذیر)
fin_posting_rule ──< fin_posting_rule_line   (قواعد سند خودکار، نسخه‌دار)
```

### ۱.۲ جدول‌های اصلی

| جدول | نقش | نکته |
|---|---|---|
| `fin_account` | درخت حساب‌ها (گروه/کل/معین/تفصیلی) | `is_leaf`, `level`, `nature` (D/C), `parent_id` |
| `fin_voucher` | سرآمد سند | `code`, `document_date`, `period_id`, `status`, `source_*`, `hash_*` |
| `fin_voucher_line` | خطوط سند | `account_id`, `debit`, `credit`, `currency_id`, `fx_rate`, `description`, ابعاد |
| `fin_line_dimension` | ابعاد تحلیلی چندگانه | `dimension_type`, `dimension_id` (EAV کنترل‌شده) |
| `fin_account_balance` | مانده ماهانه | `(account_id, period_id, branch_id)` + `opening/period_debit/period_credit/closing` |
| `fin_posting_rule` | قاعده سند خودکار | `event_type`, `version`, `condition`, `effective_from/to` |
| `fin_posting_rule_line` | خطوط قاعده | `side`, `account_expr`, `amount_expr`, `dimension_map` |
| `fin_voucher_link` | ارتباط اسناد | `type`: `REVERSAL`, `ADJUSTMENT`, `SETTLEMENT` |
| `fin_tax_rate` | نرخ مالیات/عوارض | `code`, `rate`, `effective_from` |

### ۱.۳ DDL هسته

```sql
CREATE TABLE fin_account (
  id            uuid PRIMARY KEY,
  code          varchar(32) NOT NULL UNIQUE,
  parent_id     uuid REFERENCES fin_account(id),
  level         smallint NOT NULL,       -- 1..4
  group_code    smallint NOT NULL,       -- 1=دارایی 2=بدهی 3=سرمایه 4=درآمد 5=هزینه 6=انتظامی
  nature        char(1) NOT NULL,        -- 'D' بدهکار، 'C' بستانکار
  name_fa       varchar(200) NOT NULL,
  name_en       varchar(200),
  is_leaf       boolean NOT NULL DEFAULT true,
  is_postable   boolean NOT NULL DEFAULT true,
  currency_id   uuid REFERENCES core_currency(id),
  is_active     boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE fin_voucher (
  id             uuid PRIMARY KEY,
  code           varchar(32) NOT NULL,
  branch_id      uuid NOT NULL REFERENCES core_branch(id),
  fiscal_year_id uuid NOT NULL REFERENCES core_fiscal_year(id),
  period_id      uuid NOT NULL REFERENCES core_fiscal_period(id),
  document_date  date NOT NULL,
  status         smallint NOT NULL,      -- 0 draft,1 pending,2 approved,3 posted,4 reversed,5 void
  source_type    varchar(64),            -- sales_invoice, bank_line, ...
  source_id      uuid,
  description    varchar(500) NOT NULL,
  total_debit    numeric(20,4) NOT NULL,
  total_credit   numeric(20,4) NOT NULL,
  currency_id    uuid NOT NULL REFERENCES core_currency(id),
  fx_rate        numeric(20,10) NOT NULL DEFAULT 1,
  created_by     uuid NOT NULL,
  created_at     timestamptz NOT NULL DEFAULT now(),
  posted_by      uuid,
  posted_at      timestamptz,
  reversed_by_id uuid REFERENCES fin_voucher(id),
  hash_prev      varchar(64),
  hash_current   varchar(64),
  CONSTRAINT ck_balanced CHECK (total_debit = total_credit),
  CONSTRAINT ck_positive CHECK (total_debit >= 0),
  CONSTRAINT uq_voucher_code UNIQUE (branch_id, fiscal_year_id, code)
);

CREATE TABLE fin_voucher_line (
  id           uuid PRIMARY KEY,
  voucher_id   uuid NOT NULL REFERENCES fin_voucher(id) ON DELETE RESTRICT,
  line_no      smallint NOT NULL,
  account_id   uuid NOT NULL REFERENCES fin_account(id),
  debit        numeric(20,4) NOT NULL DEFAULT 0,
  credit       numeric(20,4) NOT NULL DEFAULT 0,
  currency_id  uuid NOT NULL,
  amount_fx    numeric(20,4),
  description  varchar(500),
  party_id     uuid REFERENCES core_party(id),
  cost_center_id uuid REFERENCES fin_cost_center(id),
  project_id   uuid REFERENCES fin_project(id),
  garden_id    uuid REFERENCES core_garden(id),
  cold_room_id uuid REFERENCES inv_cold_room(id),
  vehicle_id   uuid REFERENCES core_vehicle(id),
  employee_id  uuid REFERENCES hr_employee(id),
  CONSTRAINT ck_one_side CHECK ( (debit > 0 AND credit = 0) OR (credit > 0 AND debit = 0) )
);
CREATE INDEX ix_fvl_account_date ON fin_voucher_line(account_id);
CREATE INDEX ix_fvl_party ON fin_voucher_line(party_id) WHERE party_id IS NOT NULL;
```

### ۱.۴ قواعد سطح دیتابیس (تضمین VIS-01)

| Trigger | کار |
|---|---|
| `trg_voucher_balance` | پس از درج/ویرایش خط، جمع بدهکار و بستانکار را کنترل و در سرآمد به‌روز می‌کند |
| `trg_voucher_immutable` | تغییر/حذف `fin_voucher` یا خطوط آن با `status IN (2,3,4)` را رد می‌کند |
| `trg_line_account_postable` | خط به حساب غیربرگ رد می‌شود |
| `trg_period_open` | ثبت در دوره `CLOSED/LOCKED` رد می‌شود |
| `trg_hash_chain` | `hash_current = sha256(hash_prev ‖ fields)` در زمان ثبت |

---

## ۲. موتور ثبت (Posting Engine)

### ۲.۱ ورودی و خروجی

```csharp
record PostingRequest(
    string EventType,          // "sal.invoice.posted"
    Guid SourceId,
    DateOnly DocumentDate,
    Guid BranchId,
    Money TotalBase,
    IReadOnlyDictionary<string, object> Data,
    string CorrelationId);

record PostingResult(
    Guid? VoucherId,
    string? Code,
    IReadOnlyList<PostingWarning> Warnings,
    bool Balanced);
```

### ۲.۲ الگوریتم

```
1. قواعد فعال را برای EventType و تاریخ سند بیاب (version با effective_from ≤ document_date)
2. اگر هیچ قاعده‌ای نبود:
      if config.require_rule == true → خطا (VIS-01)
      else → هشدار + سند در صف «نیازمند قاعده»
3. برای هر خط قاعده:
      account = ResolveAccount(account_expr, context)     // کد ثابت یا عبارت
      amount  = Evaluate(amount_expr, context)            // فرمول روی داده رویداد
      dims    = MapDimensions(dimension_map, context)
      اگر account غیربرگ یا غیرفعال → خطای صریح
4. کنترل تراز: |Σdebit − Σcredit| ≤ 0.01  → در غیر این صورت Rollback
5. کنترل‌های تکمیلی: حساب‌های نقدی/بانکی نیازمند بُعد، حساب‌های درآمدی نیازمند مرکز فروش
6. درج سند با status = POSTED، تولید شماره، محاسبه هش زنجیره‌ای
7. به‌روزرسانی fin_account_balance و Outbox(event: fin.voucher.posted)
```

### ۲.۳ حل حساب (Account Resolution)

| روش | مثال | استفاده |
|---|---|---|
| کد ثابت | `1103` | حساب بانک پیش‌فرض |
| نگاشت از داده پایه | `party.default_bank_account_id → 1103/tafzili` | حساب بانکی مشتری |
| جدول نگاشت | `item.inventory_account_id` | حساب موجودی هر گروه کالا |
| قاعده شرطی | `if is_export → 4104 else 4101` | تفکیک درآمد |
| حساب واسط | `1109` (شناور تسویه) | وقتی طرف حساب هنوز شناسایی نشده |

**اصل:** حساب‌ها در داده پایه تعریف می‌شوند، نه در کد. تغییر حساب پیش‌فرض بانک ملت نباید نیازمند انتشار نسخه باشد.

### ۲.۴ نمایش سند خودکار برای کاربر

کاربر مالی، بالای هر سند عملیاتی می‌بیند:

```
سند حسابداری مرتبط: 140407-00891   [مشاهده]   [چاپ]
   بدهکار ۱٬۵۱۹٬۰۰۰٬۰۰۰ ریال   بستانکار ۱٬۵۱۹٬۰۰۰٬۰۰۰ ریال   ✔ متوازن
```

و در صورت نبود سند: هشدار قرمز با دلیل و دکمه «ایجاد/اصلاح قاعده» برای حسابرس.

---

## ۳. تغییرناپذیری، برگشت و اصلاح

### ۳.۱ برگشت (Reversal)

```
سند اصلی 140407-00891 (POSTED)
   └─ سند برگشت 140407-00915:
        Dr حساب‌هایی که بستانکار بودند
        Cr حساب‌هایی که بدهکار بودند
        توضیح: «برگشت سند 140407-00891 — دلیل: ...»
        status = POSTED، link_type = REVERSAL، reversed_by_id = اصلی
```

| قاعده | جزئیات |
|---|---|
| تاریخ برگشت | نمی‌تواند قبل از تاریخ سند اصلی باشد |
| دوره برگشت | باید باز باشد؛ اگر بسته شد، در دوره جاری با یادداشت |
| اثر | مانده سند اصلی و برگشت در گزارش با هم صفر می‌شوند، اما هر دو در دفتر می‌مانند |
| ممنوعیت | برگشت یک سند برگشت ممنوع؛ برای بازگرداندن، سند جدید لازم است |

### ۳.۲ اصلاح (Adjustment)
برای اصلاح جزئی (مثلاً اختلاف ۱٪ در مبلغ): سند اصلاحی با خطوط تفاضلی، ارجاع به سند اصلی، شرح دلیل، مجوز `fin.voucher.adjust`.

### ۳.۳ هش زنجیره‌ای
هر سند در زمان ثبت هش می‌گیرد:
```
hash_current = SHA256( hash_prev ‖ code ‖ document_date ‖ Σ(debit|credit|account) )
```
گزارش `RPT-SEC-003` زنجیره را بازسازی می‌کند؛ هر شکست = نشانه دستکاری مستقیم DB.

---

## ۴. مانده‌ها و محاسبه

| موضوع | تصمیم |
|---|---|
| منبع حقیقت | خطوط سند (`fin_voucher_line`) |
| مانده تجمیعی | `fin_account_balance` (ماهانه)، بازسازی با `fn_rebuild_balances(date_from)` |
| محاسبه مانده لحظه‌ای | `opening + Σ period_debit − Σ period_credit` بسته به ماهیت حساب |
| مانده طرف حساب | View `vw_party_balance` از خطوط با `party_id` |
| Aging | از `vw_party_open_items` بر پایه فاکتورهای تسویه‌نشده |
| حسابرسی | هر شب جمع MV با جمع خطوط مقایسه؛ اختلاف → هشدار |

**تست طلایی:** `Sum(all debit) = Sum(all credit)` در هر مقطع، و `Σ closing دوره n = opening دوره n+1`.

---

## ۵. مالیات، عوارض و کسورات

| موضوع | مدل |
|---|---|
| مالیات بر ارزش افزوده فروش | بستانکار `2106`؛ در فاکتور نمایش داده می‌شود |
| مالیات خرید (اعتبار) | بدهکار `1108`؛ در تسویه با `2106` تهاتر |
| معافیت کشاورزی | پرچم `is_tax_exempt` روی کالا؛ سند بدون خط مالیات |
| عوارض صنفی | حساب `2107`/`5114` بر اساس تنظیمات |
| کسورات صافی | کاهنده درآمد (`4108`) یا هزینه، بسته به نوع — مطابق JE-SAL-001 |
| تکلیف مالیاتی | گردش مالیات در `RPT-TAX-001/002` برای اظهارنامه |

> نرخ‌ها در `fin_tax_rate` با `effective_from` هستند. تغییر نرخ، اسناد گذشته را تغییر نمی‌دهد.

---

## ۶. بستن دوره و سال

### ۶.۱ ترتیب بستن ماه

```
1. کنترل ورودی‌های ناتمام: پیش‌نویس‌های قدیمی، Import تأییدنشده، صف تأیید
2. کنترل تخصیص‌نیافته: خطوط بدون مرکز هزینه/باغ/سردخانه → RPT-FIN-021
3. کنترل مغایرت انبار ↔ دفتر → RPT-INV-010
4. کنترل تنخواه/صندوق منفی
5. محاسبه استهلاک و حقوق معوق (اگر لازم)
6. تراز آزمایشی: باید متوازن و بدون حساب غیرعادی
7. تغییر وضعیت دوره: OPEN → SOFT_CLOSED (فقط مجوزدار) → CLOSED
8. قفل: ثبت جدید رد؛ فقط اسناد اصلاحی با مجوز
```

### ۶.۲ بستن سال

```
1. بستن ۱۲ دوره
2. سند بستن: انتقال حساب‌های موقت (درآمد/هزینه) به سود و زیان جاری
3. انتقال سود/زیان به سود انباشته (3102)
4. ایجاد سال مالی جدید با مانده‌های افتتاحیه (سند افتتاحیه)
5. قفل سال: ثبت و برگشت ممنوع مگر با مجوز بازگشایی مدیر سیستم + لاگ
```

**قاعده:** سند افتتاحیه سال جدید باید دقیقاً با مانده پایانی سال قبل برابر باشد (تست خودکار).

---

## ۷. یکپارچگی با سایر ماژول‌ها

| ماژول | اثر مالی | قاعده |
|---|---|---|
| خرید | ورود موجودی + بدهی باغدار | JE-PUR-001..004 |
| فروش | مطالبات + درآمد + COGS + کسورات | JE-SAL-001..006 |
| باسکول | تا زمان قیمت‌گذاری، بدون اثر مالی (فقط مقداری) | JE-WB-001 در صورت پرداخت فوری |
| انبار | تعدیل، انتقال (بدون اثر ریالی در انتقال) | JE-INV-001 |
| تولید/بسته‌بندی | تبدیل موجودی + جذب هزینه | JE-PRD-001..003 |
| خزانه | دریافت/پرداخت/حواله | JE-TRS-001..005 |
| بانک/Import | ثبت تراکنش، تطبیق | JE-BNK-001..004 |
| پرسنل | حقوق، بیمه، مالیات | JE-HR-001..003 |
| دارایی ثابت | استهلاک | JE-AST-001 |

**قاعده منع دوباره‌شماری:** هر رویداد فقط **یک** سند مالی می‌سازد. اگر دو ماژول باید اثر بگذارند، همه خطوط در **یک سند** جمع می‌شوند (مثلاً فروش: درآمد + COGS + کسورات در یک سند).

---

## ۸. کنترل کیفیت حسابداری

| کنترل | تواتر | اقدام |
|---|---|---|
| تراز کل | هر ثبت + شبانه | هشدار فوری |
| حساب‌های با ماهیت معکوس (بانک بستانکار، درآمد بدهکار) | شبانه | گزارش بررسی |
| سند بدون بُعد | روزانه | گزارش تخصیص‌نیافته |
| سند با مبلغ صفر | روزانه | رد در ثبت |
| سند تکراری (منبع یکسان) | شبانه | گزارش |
| زنجیره هش | هفتگی | گزارش دستکاری |
| اختلاف موجودی/دفتر | ماهانه | تعدیل |

---

## ۹. نمونه: از فاکتور تا دفتر کل

فاکتور `S14-002381`: فروش ۵٬۰۰۰ کیلوگرم به فی ۳۲۰٬۰۰۰ ریال = ۱٬۶۰۰٬۰۰۰٬۰۰۰ ریال؛ صافی ۰٫۷۵٪ = ۱۲٬۰۰۰٬۰۰۰؛ حمل ۴۵٬۰۰۰٬۰۰۰؛ کمیسیون ۰٫۵٪ = ۸٬۰۰۰٬۰۰۰؛ بارگری ۱۲٬۰۰۰٬۰۰۰.

| # | حساب | شرح | بدهکار | بستانکار | ابعاد |
|---|---|---|---|---|---|
| 1 | 11031 دریافتنی از بارفروشان | فاکتور S14-002381 | ۱٬۵۲۳٬۰۰۰٬۰۰۰ | — | مشتری، شعبه |
| 2 | 4108 کسورات و برگشت فروش | صافی ۰٫۷۵٪ | ۱۲٬۰۰۰٬۰۰۰ | — | کانال، مرکز فروش |
| 3 | 5105 هزینه حمل | حمل تهران | ۴۵٬۰۰۰٬۰۰۰ | — | خودرو، مرکز هزینه حمل |
| 4 | 5106 هزینه کمیسیون | کمیسیون واسطه | ۸٬۰۰۰٬۰۰۰ | — | طرف حساب واسطه |
| 5 | 5107 بارگری و کارگر | تخلیه و بارگیری | ۱۲٬۰۰۰٬۰۰۰ | — | مرکز هزینه |
| 6 | 4101 فروش مرکبات درجه یک | ۵٬۰۰۰ kg | — | ۱٬۶۰۰٬۰۰۰٬۰۰۰ | محصول، لات، سردخانه |
| 7 | 5101 بهای تمام‌شده فروش | ۵٬۰۰۰ kg × ۲۴٬۰۰۰ | ۱۲۰٬۰۰۰٬۰۰۰ | — | لات |
| 8 | 1203 موجودی آماده فروش | خروج ۵٬۰۰۰ kg | — | ۱۲۰٬۰۰۰٬۰۰۰ | لات، سردخانه |

جمع: بدهکار ۱٬۷۲۰٬۰۰۰٬۰۰۰ = بستانکار ۱٬۷۲۰٬۰۰۰٬۰۰۰ ✔

**دفتر کل 4101 در همین سند:** بستانکار ۱٬۶۰۰٬۰۰۰٬۰۰۰ — و در گزارش سود و زیان، درآمد خالص = ۱٬۶۰۰٬۰۰۰٬۰۰۰ − ۱۲٬۰۰۰٬۰۰۰ (کسورات) = ۱٬۵۸۸٬۰۰۰٬۰۰۰؛ سود ناخالص = درآمد خالص − ۱۲۰٬۰۰۰٬۰۰۰ (COGS) − ۶۵٬۰۰۰٬۰۰۰ (حمل و کمیسیون و بارگری) = ۱٬۴۰۳٬۰۰۰٬۰۰۰ ریال.

---

## ۱۰. پذیرش

- [ ] درج سند ناتراز در DB ناممکن است (تست مستقیم SQL).
- [ ] ویرایش سند POSTED در API و DB رد می‌شود.
- [ ] برگشت، مانده سند اصلی را صفر می‌کند و هر دو در دفتر می‌مانند.
- [ ] برای هر ۲۰ رویداد عملیاتی، قاعده Posting فعال و تست‌شده وجود دارد.
- [ ] بازسازی مانده‌ها با MV برابر است (تلورانس صفر).
- [ ] سند افتتاحیه سال جدید = مانده پایانی سال قبل.
