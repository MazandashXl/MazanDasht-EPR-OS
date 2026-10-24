# مدل مجوزها و امنیت

سند مرجع: `MD-SEC-001` · نسخه ۱.۰ · مالک: معمار ERP · بازبین: حسابرس مالی

---

## ۱. لایه‌های کنترل دسترسی

```
1. احراز هویت (Authentication)
   ├─ نام کاربری/رمز (Argon2id)
   ├─ کارت/بارکد پرسنلی (اختیاری)
   ├─ احراز دو مرحله‌ای برای نقش‌های حساس
   └─ اتصال دستگاه (Device Binding) برای کلاینت‌های ثابت

2. مجوز کارکردی (Functional Permission)
   └─ PRM.<module>.<entity>.<action>      مثال: sal.invoice.post

3. دامنه داده (Data Scope)
   ├─ شعبه / انبار / صندوق مجاز
   ├─ رکوردهای خود کاربر (Created by me)
   └─ سطح مبلغ (مثلاً تأیید تا ۵۰۰ میلیون)

4. کنترل سطح فیلد (Field-level)
   └─ پنهان‌سازی حقوق، سود، شماره حساب بانکی
```

**قاعده:** مجوز کارکردی بدون دامنه داده کافی نیست. «مدیر فروش» مجوز دیدن فاکتور دارد، اما فقط فاکتورهای شعبه خودش.

---

## ۲. نام‌گذاری مجوزها

```
PRM.<domain>.<entity>.<action>
```
| بخش | مقادیر نمونه |
|---|---|
| domain | `sys`, `fin`, `sal`, `pur`, `wb`, `inv`, `prd`, `trs`, `bnk`, `imp`, `crm`, `hr`, `ast`, `bi`, `rpt`, `prt` |
| entity | `invoice`, `ticket`, `voucher`, `party`, `template` |
| action | `view`, `create`, `post`, `approve`, `void`, `reverse`, `export`, `manage`, `override` |

**قواعد:** کوچک، انگلیسی، نقطه‌ای؛ یک مجوز = یک توانایی؛ مجوزهای ترکیبی ناسازگار ممنوع («دیدن و ثبت» جدا از «تأیید»).

---

## ۳. کاتالوگ مجوزها (نسخه ۱.۰)

### سیستم و امنیت
`sys.user.manage`, `sys.role.manage`, `sys.setting.manage`, `sys.period.close`, `sys.period.reopen`, `sys.year.close`, `sys.audit.view`, `sys.backup.run`, `sys.device.manage`, `sys.future_date`, `sys.export.bulk`

### مالی
`fin.account.view`, `fin.account.manage`, `fin.voucher.create`, `fin.voucher.post`, `fin.voucher.approve`, `fin.voucher.reverse`, `fin.voucher.adjust`, `fin.report.view`, `fin.baddebt.approve`

### خزانه و بانک
`trs.receipt.create`, `trs.payment.create`, `trs.payment.approve`, `trs.cheque.create`, `trs.cheque.settle`, `trs.cash.count`, `bnk.account.manage`, `bnk.recon.view`, `bnk.recon.approve`

### خرید و باسکول
`pur.invoice.create`, `pur.invoice.post`, `pur.invoice.void`, `pur.settle`, `pur.advance.pay`, `pur.price.override`, `wb.ticket.create`, `wb.ticket.weigh`, `wb.ticket.price`, `wb.ticket.approve`, `wb.ticket.post`, `wb.ticket.void`, `wb.ticket.reverse`, `wb.manual_weight`, `wb.override_loss`, `wb.cash.pay`

### فروش
`sal.invoice.view`, `sal.invoice.create`, `sal.invoice.post`, `sal.invoice.void`, `sal.invoice.reverse`, `sal.price.manage`, `sal.deduction.manage`, `sal.discount.grant`, `sal.credit.override`, `sal.return.create`, `sal.settle`, `sal.commission.view`

### انبار و تولید
`inv.move.create`, `inv.move.post`, `inv.transfer`, `inv.count.create`, `inv.count.approve`, `inv.adjust`, `inv.waste.record`, `inv.lot.view`, `inv.cold.manage`, `prd.workorder.create`, `prd.sort.record`, `prd.pack.record`, `prd.close`, `prd.reopen`, `prd.cost.view`

### Import و داده
`imp.batch.upload`, `imp.batch.review`, `imp.batch.post`, `imp.batch.rollback`, `imp.template.manage`, `imp.rule.manage`, `core.party.create`, `core.party.manage`, `core.item.manage`, `core.basket.manage`

### CRM، پرسنل، دارایی
`crm.customer.create`, `crm.customer.view`, `crm.interaction.log`, `hr.employee.manage`, `hr.payroll.run`, `hr.payroll.approve`, `hr.salary.view`, `ast.asset.manage`, `ast.depreciation.run`

### BI، گزارش، چاپ
`bi.view.dashboard`, `bi.view.profit`, `bi.view.customer_profit`, `bi.view.cashflow`, `rpt.view`, `rpt.export`, `prt.template.manage`, `prt.print`

---

## ۴. دامنه داده (Data Scope)

```sql
CREATE TABLE sys_user_scope (
  user_id uuid NOT NULL,
  scope_type smallint NOT NULL,   -- BRANCH, WAREHOUSE, CASHBOX, COST_CENTER, SELF_ONLY
  scope_id uuid,
  PRIMARY KEY (user_id, scope_type, scope_id)
);
```

| نوع دامنه | اثر |
|---|---|
| BRANCH | فقط اسناد شعبه(های) مجاز |
| WAREHOUSE | فقط موجودی/حرکات انبار مجاز |
| CASHBOX | فقط صندوق/تنخواه مجاز |
| COST_CENTER | فقط هزینه‌های مرکز مجاز |
| SELF_ONLY | فقط رکوردهای خود کاربر |
| AMOUNT_LIMIT | سقف مبلغ برای تأیید/پرداخت |

**پیاده‌سازی:** فیلتر در سطح Query (`IQueryFilter`) + کنترل در Command (نه فقط UI). تست نفوذ: کاربر شعبه A با فراخوانی مستقیم API شناسه سند شعبه B، پاسخ `403`.

---

## ۵. تفکیک وظایف (SoD)

| تعارض | قاعده |
|---|---|
| ثبت‌کننده سند = تأییدکننده | ممنوع (پیش‌فرض) |
| سازنده پرداخت = تأییدکننده پرداخت | ممنوع |
| سازنده چک = امضاکننده | ممنوع |
| تنظیم مجوز = استفاده‌کننده از مجوز حساس | ممنوع بدون تأیید دوم |
| شمارش انبار = تأیید تعدیل | ممنوع |
| ثبت Import = تأیید Import > ۱۰۰ ردیف | ممنوع |

**استثنا:** فقط با مجوز `sys.sod.override` و ثبت اجباری دلیل در Audit + گزارش ماهانه به مدیرعامل.

---

## ۶. امنیت فنی

| موضوع | تصمیم |
|---|---|
| رمز | Argon2id (m=64MB, t=3, p=4)، حداقل ۱۰ کاراکتر، عدم استفاده از رمزهای رایج |
| نشست | JWT دسترسی ۱۵ دقیقه + Refresh ۸ ساعت، ابطال با تغییر رمز |
| قفل حساب | ۵ تلاش ناموفق → قفل ۱۵ دقیقه + اعلان |
| انتقال | TLS 1.2+ اجباری؛ HSTS؛ گواهی داخلی برای LAN |
| ذخیره‌سازی | رمز نگاشت‌شده، فیلدهای حساس (شبا، کد ملی) با دسترسی محدود |
| فایل | دسترسی با مجوز + URL امضاشده موقت (نه لینک دائمی) |
| SQL | فقط پارامتری؛ گزارش‌ساز پویا با لیست سفید ستون‌ها (جلوگیری از تزریق) |
| CSRF/XSS | توکن، CSP، خروجی Escape |
| لاگ | ثبت ورود، تغییر مجوز، دسترسی به حقوق، خروجی حجیم |
| دسترسی از راه دور | VPN + 2FA + محدودیت IP |
| پشتیبان رمزنگاری | AES-256 برای آرشیو خارج از سایت |

---

## ۷. Audit Trail

| رویداد | داده ثبت‌شده |
|---|---|
| تغییر داده | entity, id, action, before, after, user, ip, at, correlation_id |
| تغییر وضعیت | from, to, reason, user |
| ورود/خروج | user, ip, device, result |
| تغییر مجوز | target user, permission, grant/revoke, actor |
| خروجی حجیم | report code, row count, filters |
| بازگشایی دوره | period, reason, actor |
| Override SoD | rule, reason, actor |

**یکپارچگی:** هش زنجیره‌ای روی اسناد مالی؛ جدول Audit فقط افزودنی (append-only) با Trigger منع UPDATE/DELETE.

---

## ۸. پاسخ به رخداد

| رخداد | اقدام |
|---|---|
| لو رفتن رمز | ابطال نشست‌ها، اجبار تغییر رمز، بررسی لاگ ۳۰ روز |
| دستکاری سند | تشخیص با زنجیره هش، بازیابی از پشتیبان، گزارش به مدیرعامل |
| چک برگشتی بزرگ | هشدار فوری، مسدودسازی مشتری تا تسویه |
| تلاش دسترسی غیرمجاز | قفل موقت، اعلان به مدیر سیستم |
| گم شدن دستگاه | ابطال Device Binding |

---

## ۹. پذیرش

- [ ] هیچ کاربری نمی‌تواند مجوز خود را تغییر دهد.
- [ ] دسترسی به سند خارج از دامنه شعبه، با API مستقیم هم رد می‌شود.
- [ ] ثبت و تأیید یک سند توسط یک نفر، پیش‌فرض ممکن نیست.
- [ ] Audit فقط افزودنی است (تلاش Update/Delete رد می‌شود).
- [ ] آزمون نفوذ پایه (OWASP Top 10) بدون یافته بحرانی.
- [ ] هر دسترسی به «حقوق» و «سود مشتری» لاگ می‌شود.
