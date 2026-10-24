# موتور گردش کار و رویدادهای دامنه

سند مرجع: `MD-ARC-003` · نسخه ۱.۰ · مالک: معمار ERP · بازبین: مدیر محصول

---

## ۱. سه مکانیزم جدا

| مکانیزم | برای چه | مثال | پیاده‌سازی |
|---|---|---|---|
| **State Machine** | چرخه عمر یک سند | فاکتور: پیش‌نویس → تأیید → ثبت → تسویه | ستون `status` + جدول مجاز انتقال + Guard |
| **Workflow/Approval** | تأیید انسانی چندمرحله‌ای | تخفیف > ۵٪ نیازمند مدیر فروش | `wf_instance`, `wf_task` |
| **Domain Event** | واکنش سایر ماژول‌ها | ثبت فروش → سند، BI، پیامک | Outbox + Handler |

> **قاعده:** State Machine برای «چه وضعیتی مجاز است»، Event برای «چه کسی باید بداند»، Workflow برای «چه کسی باید تأیید کند». این سه را قاطی نکنیم.

---

## ۲. چرخه‌های عمر استاندارد

### ۲.۱ فاکتور فروش

```
DRAFT ──confirm──► CONFIRMED ──post──► POSTED ──settle──► PARTIALLY_SETTLED ──► SETTLED
  │                   │                  │
  └────void──────────►└─────void────────►└────reverse────► REVERSED
```

| انتقال | مجوز | پیش‌شرط | اثر |
|---|---|---|---|
| DRAFT→CONFIRMED | `sales.invoice.confirm` | موجودی/اعتبار/قیمت معتبر | قفل ویرایش خطوط |
| CONFIRMED→POSTED | `sales.invoice.post` | تأیید مالی، دوره باز | سند JE-SAL-001، خروج انبار، BI |
| POSTED→REVERSED | `sales.invoice.reverse` | دلیل اجباری | سند برگشتی + بازگشت انبار |
| DRAFT→VOID | `sales.invoice.void` | — | بدون اثر مالی |

### ۲.۲ قبض باسکول

```
DRAFT(وزن اول) ──second_weigh──► WEIGHED ──price──► PRICED ──approve──► APPROVED ──post──► POSTED
      │                             │                 │                     │
      └────────void────────────────►└────void────────►└──────void──────────►└──reverse──► REVERSED
```

قاعده کلیدی: **قبض تا زمانی که وزن دوم ثبت نشده، «قبض» نیست** (در حالت دو مرحله‌ای) و قابل چاپ نهایی/استناد مالی نیست.

### ۲.۳ حواله انبار / سند حسابداری / چک

| سند | چرخه |
|---|---|
| حواله انبار | `DRAFT → APPROVED → POSTED → (REVERSED)` |
| سند حسابداری | `DRAFT → PENDING_APPROVAL → APPROVED → POSTED → REVERSED` |
| چک دریافتی | `RECEIVED → IN_COLLECTION → CLEARED / BOUNCED → (RETURNED_TO_PARTY)` |
| چک پرداختی | `ISSUED → PRESENTED → CLEARED / BOUNCED → (REISSUED)` |
| Import Batch | `UPLOADED → MAPPED → VALIDATED → REVIEWED → POSTING → POSTED / PARTIAL / ROLLED_BACK` |
| دوره مالی | `OPEN → SOFT_CLOSED → CLOSED → LOCKED` |

### ۲.۴ جدول پیاده‌سازی انتقال

```sql
CREATE TABLE sys_state_transition (
  entity      varchar(64) NOT NULL,
  from_status varchar(32) NOT NULL,
  to_status   varchar(32) NOT NULL,
  permission  varchar(80) NOT NULL,
  guard_fn    varchar(120),         -- تابع اعتبارسنجی
  requires_reason boolean NOT NULL DEFAULT false,
  PRIMARY KEY (entity, from_status, to_status)
);
```

هر انتقال نامعتبر، در سرویس دامنه رد می‌شود؛ هیچ کدی مستقیماً `status` را `UPDATE` نمی‌کند.

---

## ۳. کاتالوگ رویدادهای دامنه

قالب نام: `<module>.<entity>.<action>` — گذشته، نه امری.

| رویداد | محمل | مصرف‌کننده‌ها | اثر |
|---|---|---|---|
| `wb.ticket.created` | قبض باسکول | داشبورد، انبار | صف زنده، پیش‌حواله |
| `wb.ticket.weighed` | وزن کامل شد | انبار، خرید | ایجاد حواله ورود |
| `wb.ticket.priced` | فی گذاشته شد | خرید، BI | آمادگی فاکتور |
| `wb.ticket.voided` | ابطال | BI، انبار | برگشت حواله |
| `pur.invoice.posted` | خرید ثبت شد | حسابداری، انبار، BI | JE-PUR-001، ورود موجودی |
| `sal.invoice.posted` | فروش ثبت شد | حسابداری، انبار، BI، پیامک | JE-SAL-001..004، خروج |
| `sal.invoice.settled` | تسویه کامل | خزانه، BI، CRM | بستن مانده |
| `sal.return.posted` | برگشت فروش | حسابداری، انبار | JE-SAL-006 |
| `inv.move.posted` | حرکت انبار | BI، خرید (هشدار موجودی) | به‌روزرسانی موجودی |
| `inv.count.approved` | شمارش تأیید شد | حسابداری | سند تعدیل |
| `prd.sort.completed` | سورت تمام شد | انبار، BI | لات‌های خروجی، ضایعات |
| `prd.pack.completed` | بسته‌بندی تمام شد | انبار، حسابداری | مصرف کارتن، بهای تمام‌شده |
| `fin.voucher.posted` | سند ثبت شد | BI، مانده‌ها | به‌روزرسانی مانده حساب |
| `fin.period.closed` | دوره بسته شد | همه | قفل ثبت |
| `trs.receipt.posted` | رسید دریافت | CRM، BI | کاهش مانده |
| `trs.payment.posted` | پرداخت | BI | افزایش مانده پرداختی |
| `trs.cheque.bounced` | چک برگشت | CRM، حسابداری، BI | سند برگشتی، هشدار اعتباری |
| `bnk.statement.imported` | صورتحساب وارد شد | حسابداری | ردیف‌های پیشنهادی |
| `bnk.reconciliation.completed` | تطبیق انجام شد | BI | مانده تأییدشده |
| `imp.batch.posted` | Import ثبت شد | حسابداری، BI | اسناد دسته‌ای |
| `crm.interaction.logged` | تماس/پیگیری | BI | امتیاز مشتری |
| `sys.backup.completed` | پشتیبان موفق | پایش | سلامت |
| `sys.sync.conflict` | تضاد همگام‌سازی | پایش، کاربر | صف بازبینی |

### ۳.۱ قرارداد هر رویداد

```json
{
  "event_id": "01J9...",
  "event_type": "sal.invoice.posted",
  "event_version": 1,
  "occurred_at": "2026-10-10T06:12:44.183Z",
  "business_date": "2026-10-10",
  "aggregate": { "type": "sal_invoice", "id": "uuid", "version": 3 },
  "branch_id": "uuid",
  "actor": { "user_id": "uuid", "node_id": "SRV01" },
  "correlation_id": "c-7f3e",
  "causation_id": "cmd-1182",
  "payload": { "code": "S14-002381", "party_id": "uuid", "total": 52800000, "currency": "IRR" }
}
```

**قواعد:**
- رویداد تغییرناپذیر است؛ نسخه‌بندی دارد (`event_version`).
- Payload حداقلی؛ مصرف‌کننده اگر جزئیات می‌خواهد، از Query Service بخواند.
- هر رویداد در `sys_outbox` با وضعیت `PENDING/PUBLISHED/FAILED` ذخیره می‌شود.
- Handlerها Idempotent هستند (کلید `event_id`).

---

## ۴. Outbox و تحویل

```
BEGIN TX
  ... تغییرات دامنه + JE + Stock ...
  INSERT INTO sys_outbox(event_id, type, payload, status='PENDING')
COMMIT
      │
      ▼ (Background، هر ۱ ثانیه)
Publisher: SELECT ... FOR UPDATE SKIP LOCKED LIMIT 100
      ├─ Handler محلی (BI، نوتیفیکیشن)  → PUBLISHED
      └─ خطا → retry با Backoff (۱s,5s,30s,5m,30m) → بعد از ۱۰ بار: FAILED + هشدار
```

**تضمین:** «حداقل یک‌بار تحویل» + «اثر یک‌بار» از طریق Idempotency در Handler.

---

## ۵. گردش کار تأیید (Approval Workflow)

### ۵.۱ موارد نیازمند تأیید در نسخه ۱.۰

| مورد | شرط | تأییدکننده | اثر رد |
|---|---|---|---|
| تخفیف فاکتور | > ۵٪ مبلغ | مدیر فروش | بازگشت به پیش‌نویس |
| افت بار | > سقف (۱۰٪) | سرپرست باسکول | عدم ثبت |
| عبور از سقف اعتبار | مانده + فاکتور > سقف | مدیر مالی | توقف |
| پرداخت نقدی بزرگ | > سقف | مدیر مالی + مدیرعامل | توقف |
| ابطال سند ثبت‌شده | همیشه | حسابرس/مدیر مالی | بدون اثر |
| بازگشایی دوره | همیشه | مدیر مالی | — |
| تعدیل انبار | مغایرت > ۱٪ | سرپرست انبار + مالی | — |

### ۵.۲ مدل داده

```sql
CREATE TABLE wf_instance (
  id           uuid PRIMARY KEY,
  entity       varchar(64) NOT NULL,
  entity_id    uuid NOT NULL,
  status       smallint NOT NULL,   -- 0 pending, 1 approved, 2 rejected, 3 cancelled
  reason       text,
  created_at   timestamptz NOT NULL DEFAULT now(),
  created_by   uuid NOT NULL
);
CREATE TABLE wf_task (
  id           uuid PRIMARY KEY,
  instance_id  uuid NOT NULL REFERENCES wf_instance(id),
  role_code    varchar(40) NOT NULL,
  user_id      uuid,
  status       smallint NOT NULL,
  comment      text,
  acted_at     timestamptz
);
```

### ۵.۳ تجربه کاربری تأیید
- تأیید مستقیم در همان صفحه (Flyout)، بدون رفتن به ماژول دیگر.
- صف تأییدها در هدر با نشان تعداد.
- امکان تأیید گروهی با پیش‌نمایش (و ممنوعیت تأیید گروهی برای موارد حساس).

---

## ۶. نوتیفیکیشن و یادآوری

| رویداد | کانال | مخاطب | زمان |
|---|---|---|---|
| چک سرسید | درون‌برنامه + پیامک | مالی، مدیر | ۳ روز قبل |
| بدهی معوق مشتری | درون‌برنامه | فروش | روزانه |
| موجودی کارتن کم | درون‌برنامه | انبار | روزانه |
| قبض باسکول چاپ‌نشده | درون‌برنامه | سرپرست | ۲ ساعت |
| تضاد همگام‌سازی | درون‌برنامه + ایمیل | IT | فوری |
| شکست پشتیبان | ایمیل/پیامک | IT | فوری |
| صف تأیید بیش از ۲۴ ساعت | یادآوری | تأییدکننده | روزانه |

قاعده: **هر نوتیفیکیشن باید یک اقدام داشته باشد** (لینک مستقیم به سند). نوتیفیکیشن بدون اقدام، حذف شود.

---

## ۷. زمان‌بندی و هم‌روندی

| موضوع | تصمیم |
|---|---|
| Optimistic Concurrency | `row_version` در همه جداول قابل ویرایش؛ تضاد = `409 Conflict` |
| قفل دوره | تراکنش با `SELECT ... FOR SHARE` روی `core_fiscal_period` |
| شماره‌گذاری | `fin_voucher_seq` با `UPDATE ... RETURNING` در همان تراکنش |
| جلوگیری از ثبت هم‌زمان دو قبض برای یک خودرو | Unique partial index روی `(vehicle_id) WHERE status IN ('WEIGHED','PRICED')` |
| ترتیب رویداد | `occurred_at` + `event_id` (UUIDv7) برای مرتب‌سازی قطعی |

---

## ۸. سیاست خطا و جبران (Compensation)

| سناریو | رفتار |
|---|---|
| شکست Posting | Rollback کل تراکنش، پیام دقیق، بدون ثبت نیمه‌کاره |
| شکست Handler غیرحیاتی (پیامک) | Retry؛ عدم اثر بر سند |
| شکست چاپ پس از ثبت | رکورد در صف چاپ؛ چاپ مجدد بدون سند جدید |
| تضاد همگام‌سازی | نگه‌داشتن هر دو نسخه، صف بازبینی، اعلان |
| Import نیمه‌موفق | حالت `PARTIAL` با گزارش ردیف‌های ردشده؛ امکان اصلاح و ارسال مجدد |

---

## ۹. پذیرش

- [ ] هر انتقال وضعیت در کد از `sys_state_transition` عبور می‌کند (تست معماری).
- [ ] قطع برق در میانه ثبت سند، باعث سند نیمه‌کاره نمی‌شود (تست Chaos).
- [ ] هر رویداد حداقل یک تست Idempotency دارد.
- [ ] هر Workflow دارای تست «رد» و «تأیید» و «تأیید توسط خود ثبت‌کننده (باید رد شود)» است.
- [ ] صف Outbox در حالت عادی < ۱۰۰ و تأخیر p95 < ۲ ثانیه است.
