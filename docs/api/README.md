# کاتالوگ API

سند مرجع: `MD-API-001` · نسخه ۱.۰ · مالک: معمار ERP · بازبین: تیم فرانت‌اند

---

## ۱. قراردادهای عمومی

| موضوع | قاعده |
|---|---|
| پایه | `/api/v1` |
| احراز | `Authorization: Bearer <JWT>` |
| محتوا | `application/json; charset=utf-8` |
| نام‌گذاری | `camelCase` در JSON، `snake_case` در DB |
| تاریخ | `businessDate`: `YYYY-MM-DD` میلادی؛ نمایش شمسی در کلاینت |
| مبلغ | رشته عددی برای جلوگیری از خطای شناور (`"315085680"`) |
| وزن | رشته عددی با ۳ اعشار (`"17504.760"`) |
| ارز | `currency`, `fxRate`, `amountBase` در هر مبلغ ارزی |
| شماره‌گذاری صفحه | `page`, `pageSize` (پیش‌فرض ۲۵، حداکثر ۲۰۰) |
| مرتب‌سازی | `sort=-businessDate,code` |
| خطا | RFC 7807 (`application/problem+json`) |
| Correlation | هدر `X-Correlation-Id` (اگر نباشد، سرور تولید می‌کند) |
| Idempotency | هدر `Idempotency-Key` برای همه POSTهای مالی |
| نسخه‌بندی | نسخه در مسیر؛ تغییر ناسازگار = `v2` |

### ۱.۱ قالب خطا

```json
{
  "type": "https://mazandasht.local/errors/business-rule",
  "title": "قاعده کسب‌وکار نقض شد",
  "status": 422,
  "code": "BR-405",
  "detail": "کسور «حمل» حساب ندارد",
  "instance": "/api/v1/sales/invoices",
  "correlationId": "c-7f3e...",
  "errors": [{ "field": "deductions[1].accountId", "message": "الزامی است" }]
}
```

| کد HTTP | کاربرد |
|---|---|
| 200/201/204 | موفق |
| 400 | درخواست نامعتبر |
| 401/403 | احراز/مجوز |
| 404 | یافت نشد |
| 409 | تضاد (نسخه، وضعیت، شماره) |
| 422 | قاعده کسب‌وکار |
| 429 | محدودیت نرخ |
| 500 | خطای سرور (با `correlationId`) |

---

## ۲. احراز و نشست

```
POST   /auth/login            { username, password } → { accessToken, refreshToken, user, permissions, scopes }
POST   /auth/refresh
POST   /auth/logout
GET    /auth/me
POST   /auth/change-password
POST   /auth/mfa/enable
```

---

## ۳. هسته و داده پایه

```
GET    /core/parties?role=&q=&page=
POST   /core/parties
GET    /core/parties/{id}
PATCH  /core/parties/{id}
POST   /core/parties/{id}/block
GET    /core/items?type=&q=
POST   /core/items
GET    /core/containers            سبد/کارتن
POST   /core/containers
GET    /core/warehouses
GET    /core/gardens
GET    /core/vehicles
GET    /core/currencies
GET    /core/exchange-rates?at=
GET    /core/fiscal-periods
GET    /core/settings
PUT    /core/settings/{key}
```

---

## ۴. مالی

```
GET    /fin/accounts?tree=true
POST   /fin/accounts
GET    /fin/accounts/{id}/balance?period=
GET    /fin/vouchers?from=&to=&source=&status=
POST   /fin/vouchers
GET    /fin/vouchers/{id}
POST   /fin/vouchers/{id}/approve
POST   /fin/vouchers/{id}/post
POST   /fin/vouchers/{id}/reverse         { reason }
GET    /fin/reports/journal?from=&to=
GET    /fin/reports/trial-balance?from=&to=&level=
GET    /fin/reports/balance-sheet?at=
GET    /fin/reports/profit-loss?from=&to=
GET    /fin/reports/cash-flow?from=&to=
GET    /fin/periods/{id}/close-readiness
POST   /fin/periods/{id}/close
POST   /fin/periods/{id}/reopen            { reason }
```

---

## ۵. خزانه و بانک

```
POST   /treasury/receipts
POST   /treasury/payments
POST   /treasury/payments/{id}/approve
POST   /treasury/transfers
GET    /treasury/cheques?direction=&status=
POST   /treasury/cheques
POST   /treasury/cheques/{id}/deposit
POST   /treasury/cheques/{id}/clear
POST   /treasury/cheques/{id}/bounce        { reason }
GET    /treasury/cashboxes/{id}/balance
POST   /treasury/cashboxes/{id}/count
GET    /bank/accounts/{id}/ledger?from=&to=
POST   /bank/reconciliations
GET    /bank/reconciliations/{id}
```

---

## ۶. باسکول

```
GET    /wb/queue
POST   /wb/gate
POST   /wb/tickets
PATCH  /wb/tickets/{id}/weigh
PATCH  /wb/tickets/{id}/baskets
POST   /wb/tickets/{id}/price
POST   /wb/tickets/{id}/approve
POST   /wb/tickets/{id}/post
POST   /wb/tickets/{id}/void               { reason }
POST   /wb/tickets/{id}/reverse            { reason }
GET    /wb/tickets/by-qr/{payload}
GET    /wb/tickets/{id}/print
GET    /wb/devices/{id}/live-weight        (SSE/WebSocket)
```

---

## ۷. خرید و فروش

```
POST   /purchasing/contracts
POST   /purchasing/orders
POST   /purchasing/invoices
POST   /purchasing/invoices/{id}/post
POST   /purchasing/advances

GET    /sales/price-board?date=
POST   /sales/price-board
POST   /sales/quotations
POST   /sales/orders
POST   /sales/shipments
POST   /sales/invoices
GET    /sales/invoices/{id}
POST   /sales/invoices/{id}/post
POST   /sales/invoices/{id}/void
POST   /sales/invoices/{id}/reverse
POST   /sales/invoices/{id}/settle
POST   /sales/returns
GET    /sales/customers/{id}/statement?from=&to=
GET    /sales/customers/{id}/credit
```

نمونه درخواست فاکتور:

```json
POST /api/v1/sales/invoices
Idempotency-Key: sal:SRV01:14040718:2381
{
  "partyId": "...",
  "channelId": "...",
  "businessDate": "2026-10-10",
  "salespersonId": "...",
  "priceBasis": "PER_KG",
  "lines": [{
    "itemId": "...", "lotId": "...", "coldRoomId": "...", "grade": "A",
    "basketCount": 210, "basketTypeId": "...",
    "scaleWeightKg": "17500.000", "wastePct": "2",
    "unitPrice": "320000"
  }],
  "deductions": [
    { "typeCode": "PURITY", "calcMethod": "PCT_OF_GROSS", "rate": "0.75" },
    { "typeCode": "FREIGHT", "calcMethod": "FIXED", "amount": "45000000" },
    { "typeCode": "COMMISSION", "calcMethod": "PCT_OF_GROSS", "rate": "0.5" }
  ],
  "printTemplateId": "..."
}
→ 201 {
  "id": "...", "code": "S14-002381",
  "grossAmount": "5328000000",
  "deductionAmount": "123600000",
  "netPayable": "5204400000",
  "voucherId": "...", "voucherCode": "140407-00891",
  "warnings": []
}
```

---

## ۸. انبار و تولید

```
GET    /inventory/stock?warehouse=&item=&lot=
GET    /inventory/lots?item=&from=
GET    /inventory/lots/{id}/trace
POST   /inventory/moves
POST   /inventory/moves/{id}/post
POST   /inventory/transfers
POST   /inventory/counts
POST   /inventory/counts/{id}/approve
POST   /inventory/adjustments
POST   /inventory/reservations

POST   /production/work-orders
POST   /production/sort-runs
POST   /production/pack-runs
POST   /production/waste
POST   /production/runs/{id}/close
```

---

## ۹. Import Studio

```
POST   /import/batches                       (multipart)
GET    /import/batches/{id}/profile
GET    /import/batches/{id}/columns
PUT    /import/batches/{id}/mapping
GET    /import/batches/{id}/preview
PATCH  /import/batches/{id}/lines/{lineId}
POST   /import/batches/{id}/post
POST   /import/batches/{id}/rollback         { reason }
GET    /import/templates
POST   /import/templates
GET    /import/rules
POST   /import/rules
```

---

## ۱۰. CRM، پرسنل، دارایی، BI

```
GET    /crm/customers/{id}/360
POST   /crm/interactions
POST   /crm/complaints
GET    /crm/segments

GET    /hr/employees
POST   /hr/payroll-runs
POST   /hr/payroll-runs/{id}/calculate
POST   /hr/payroll-runs/{id}/approve
POST   /hr/payroll-runs/{id}/pay
GET    /hr/payslips/{id}

GET    /assets
POST   /assets/depreciation-run

GET    /bi/dashboard?from=&to=&branch=
GET    /bi/kpi/{code}?from=&to=
GET    /bi/profit/customer?from=&to=
GET    /bi/profit/lot?from=&to=
GET    /bi/cashflow-forecast?days=90

GET    /reports/{code}?filters...
GET    /reports/{code}/export?format=xlsx|pdf|csv
```

---

## ۱۱. همگام‌سازی و سلامت

```
POST   /sync/push
GET    /sync/pull?sinceRevision=
GET    /sync/state
POST   /sync/resolve-conflict

GET    /health
GET    /health/db
GET    /health/queues
GET    /quick-actions
GET    /help/articles?page=&q=
```

---

## ۱۲. قواعد امنیتی API

| قاعده | پیاده‌سازی |
|---|---|
| مجوز در هر Endpoint | Attribute `[RequirePermission("...")]` |
| دامنه داده | فیلتر اجباری شعبه/انبار در Query |
| نرخ | ۱۰۰ درخواست/دقیقه/کاربر؛ Import استثنا |
| حجم بدنه | ۲۵MB (فایل ۱۰۰MB در مسیر اختصاصی) |
| Audit | همه POST/PATCH/PUT/DELETE مالی |
| رمز | هرگز در پاسخ و لاگ |
| فیلد حساس | حذف از پاسخ برای نقش‌های غیرمجاز (مثلاً حقوق) |

---

## ۱۳. پذیرش

- [ ] هر Endpoint دارای مجوز و تست دسترسی منفی است.
- [ ] همه POSTهای مالی Idempotency را پشتیبانی می‌کنند.
- [ ] هیچ پاسخ مالی بدون `voucherId` (در صورت وجود سند) نیست.
- [ ] OpenAPI معتبر و به‌روز تولید می‌شود (`/openapi/v1.json`).
- [ ] خطاها همیشه فارسی و دارای `code` و `correlationId` هستند.
