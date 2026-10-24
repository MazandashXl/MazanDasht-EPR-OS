#!/usr/bin/env python3
"""تولید فایل seed حساب‌ها و نقش‌ها از تعریف فشرده.

منبع تعریف: docs/accounting/chart-of-accounts.md و docs/security/roles-matrix.md
خروجی: database/seed/chart_of_accounts.sql ، database/seed/roles.sql

اجرا:
    python3 tools/gen_seed.py
"""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SEED = ROOT / "database" / "seed"

# (code, parent, name_fa, nature, postable)
# سطح از طول کد تعیین می‌شود: 1 نگاشت گروه، 2 کل، 3 معین، 5 تفصیلی
ACCOUNTS: list[tuple[str, str, str, str, bool]] = [
    # سطح ۱ — گروه‌ها
    ("1", "", "دارایی‌ها", "D", False),
    ("2", "", "بدهی‌ها", "C", False),
    ("3", "", "سرمایه", "C", False),
    ("4", "", "درآمدها", "C", False),
    ("5", "", "هزینه‌ها", "D", False),
    ("6", "", "حساب‌های انتظامی", "D", False),
    # 11 دارایی جاری
    ("11", "1", "دارایی‌های جاری", "D", False),
    ("1101", "11", "صندوق", "D", False),
    ("11011", "1101", "صندوق مرکزی", "D", True),
    ("11012", "1101", "تنخواه خرید", "D", True),
    ("11013", "1101", "صندوق باسکول", "D", True),
    ("1102", "11", "بانک‌ها", "D", False),
    ("11021", "1102", "بانک ملت — جاری اصلی", "D", True),
    ("11022", "1102", "بانک ملی — جاری", "D", True),
    ("11023", "1102", "بانک تجارت — جاری", "D", True),
    ("11024", "1102", "بانک صادرات — جاری", "D", True),
    ("11025", "1102", "بانک سپه — جاری", "D", True),
    ("11026", "1102", "بانک پاسارگاد — جاری", "D", True),
    ("11027", "1102", "حساب ارزی — دلار", "D", True),
    ("11028", "1102", "حساب ارزی — یورو", "D", True),
    ("1103", "11", "حساب‌های دریافتنی تجاری", "D", False),
    ("11031", "1103", "دریافتنی از بارفروشان", "D", True),
    ("11032", "1103", "دریافتنی از عمده‌فروشان", "D", True),
    ("11033", "1103", "دریافتنی صادراتی", "D", True),
    ("11034", "1103", "دریافتنی متفرقه", "D", True),
    ("1104", "11", "اسناد دریافتنی (چک)", "D", False),
    ("11041", "1104", "چک‌های در جریان وصول", "D", True),
    ("11042", "1104", "چک‌های نزد صندوق", "D", True),
    ("11043", "1104", "چک‌های تضمینی", "D", True),
    ("1105", "11", "پیش‌پرداخت‌ها", "D", False),
    ("11051", "1105", "پیش‌پرداخت به باغداران", "D", True),
    ("11052", "1105", "پیش‌پرداخت به تأمین‌کنندگان", "D", True),
    ("1106", "11", "حساب واسط تسویه (شناور)", "D", True),
    ("1107", "11", "اعتبار مالیات بر ارزش افزوده", "D", False),
    ("11071", "1107", "مالیات خرید (اعتبار)", "D", True),
    ("1108", "11", "سایر دریافتنی‌ها", "D", False),
    ("11081", "1108", "علی‌الحساب کارکنان", "D", True),
    ("11082", "1108", "مساعده و وام پرسنل", "D", True),
    ("11083", "1108", "سپرده‌های پرداختی", "D", True),
    # 12 موجودی
    ("12", "1", "موجودی‌ها", "D", False),
    ("1201", "12", "موجودی میوه در سردخانه", "D", True),
    ("1202", "12", "موجودی میوه در جریان سورت", "D", True),
    ("1203", "12", "موجودی آماده فروش", "D", True),
    ("1204", "12", "کارتن و مواد بسته‌بندی", "D", True),
    ("1205", "12", "سبد و پالت", "D", True),
    ("1206", "12", "ضایعات قابل فروش", "D", True),
    ("1207", "12", "کالای در راه", "D", True),
    # 13 دارایی ثابت
    ("13", "1", "دارایی‌های ثابت", "D", False),
    ("1301", "13", "زمین", "D", True),
    ("1302", "13", "ساختمان و انبار", "D", True),
    ("1303", "13", "سردخانه و تجهیزات سرمایش", "D", True),
    ("1304", "13", "خط سورت و بسته‌بندی", "D", True),
    ("1305", "13", "خودرو و لیفتراک", "D", True),
    ("1306", "13", "اثاثه و تجهیزات اداری", "D", True),
    ("1307", "13", "استهلاک انباشته", "C", True),
    ("14", "1", "دارایی‌های نامشهود", "D", False),
    ("1401", "14", "نرم‌افزار و لایسنس", "D", True),
    ("1402", "14", "حقوق و امتیاز", "D", True),
    ("15", "1", "دارایی در جریان تکمیل", "D", True),
    # 21 بدهی جاری
    ("21", "2", "بدهی‌های جاری", "C", False),
    ("2101", "21", "حساب‌های پرداختنی — باغداران", "C", True),
    ("2102", "21", "حساب‌های پرداختنی — تأمین‌کنندگان", "C", True),
    ("2103", "21", "اسناد پرداختنی (چک)", "C", False),
    ("21031", "2103", "چک‌های پرداختنی سرسید", "C", True),
    ("21032", "2103", "چک‌های امانی", "C", True),
    ("2104", "21", "حقوق و دستمزد پرداختنی", "C", True),
    ("2105", "21", "بیمه تأمین اجتماعی پرداختنی", "C", True),
    ("2106", "21", "مالیات و عوارض پرداختنی", "C", False),
    ("21061", "2106", "مالیات بر ارزش افزوده فروش", "C", True),
    ("21062", "2106", "مالیات بر حقوق", "C", True),
    ("21063", "2106", "عوارض صنفی/شهرداری", "C", True),
    ("2107", "21", "پیش‌دریافت از مشتریان", "C", True),
    ("2108", "21", "صافی و کسورات پرداختنی", "C", True),
    ("2109", "21", "هزینه‌های شناسایی‌شده پرداخت‌نشده", "C", True),
    ("22", "2", "وام و تسهیلات", "C", False),
    ("2201", "22", "وام کوتاه‌مدت", "C", True),
    ("2202", "22", "وام بلندمدت", "C", True),
    ("23", "2", "بدهی بلندمدت و اجاره", "C", False),
    ("2301", "23", "اجاره پرداختنی بلندمدت", "C", True),
    # 31 سرمایه
    ("31", "3", "سرمایه و اندوخته", "C", False),
    ("3101", "31", "سرمایه اولیه", "C", True),
    ("3102", "31", "سود (زیان) انباشته", "C", True),
    ("3103", "31", "برداشت مالک", "D", True),
    ("3104", "31", "اندوخته قانونی", "C", True),
    ("3199", "31", "حساب بستن", "C", True),
    # 41 درآمد
    ("41", "4", "درآمدهای عملیاتی", "C", False),
    ("4101", "41", "فروش مرکبات درجه یک", "C", True),
    ("4102", "41", "فروش مرکبات درجه دو", "C", True),
    ("4103", "41", "فروش صنعتی و ضایعات", "C", True),
    ("4104", "41", "فروش صادراتی", "C", True),
    ("4105", "41", "درآمد خدمات بسته‌بندی", "C", True),
    ("4106", "41", "کرایه حمل دریافتنی", "C", True),
    ("4107", "41", "تخفیف نقدی فروش", "D", True),
    ("4108", "41", "برگشت از فروش و کسورات (صافی)", "D", True),
    ("4109", "41", "درآمد متفرقه", "C", True),
    # 51 بهای تمام‌شده
    ("51", "5", "بهای تمام‌شده و هزینه‌های مستقیم", "D", False),
    ("5101", "51", "بهای تمام‌شده میوه فروش‌رفته", "D", True),
    ("5102", "51", "دستمزد سورت و بسته‌بندی", "D", True),
    ("5103", "51", "کارتن و مواد بسته‌بندی مصرفی", "D", True),
    ("5104", "51", "ضایعات و افت غیرعادی", "D", True),
    ("5105", "51", "هزینه حمل فروش", "D", True),
    ("5106", "51", "کمیسیون فروش", "D", True),
    ("5107", "51", "بارگری و کارگر", "D", True),
    # 52 عملیاتی
    ("52", "5", "هزینه‌های عملیاتی", "D", False),
    ("5201", "52", "حقوق و دستمزد", "D", True),
    ("5202", "52", "بیمه سهم کارفرما", "D", True),
    ("5203", "52", "برق", "D", True),
    ("5204", "52", "آب و گاز", "D", True),
    ("5205", "52", "سوخت خودرو و لیفتراک", "D", True),
    ("5206", "52", "تعمیر و نگهداشت سردخانه", "D", True),
    ("5207", "52", "تعمیر خودرو", "D", True),
    ("5208", "52", "اجاره", "D", True),
    ("5209", "52", "ملزومات و مصرفی", "D", True),
    ("5210", "52", "ارتباطات و اینترنت", "D", True),
    ("5211", "52", "پذیرایی، سفر و مأموریت", "D", True),
    ("5212", "52", "خدمات پیمانکاری", "D", True),
    # 53 عمومی
    ("53", "5", "هزینه‌های عمومی و اداری", "D", False),
    ("5301", "53", "استهلاک دارایی‌ها", "D", True),
    ("5302", "53", "کارمزد و هزینه بانکی", "D", True),
    ("5303", "53", "هزینه مالی و سود تسهیلات", "D", True),
    ("5304", "53", "حق‌الوکاله و مشاوره", "D", True),
    ("5305", "53", "تبلیغات و بازاریابی", "D", True),
    ("5306", "53", "حمل و نقل متفرقه", "D", True),
    ("5307", "53", "جریمه، خسارت و کسورات", "D", True),
    ("5308", "53", "کسری و مغایرت انبار", "D", True),
    ("5309", "53", "سایر هزینه‌ها", "D", True),
    ("54", "5", "مالیات بر درآمد", "D", False),
    ("5401", "54", "مالیات بر درآمد", "D", True),
    # 61 انتظامی
    ("61", "6", "حساب‌های انتظامی", "D", False),
    ("6101", "61", "چک‌های در جریان وصول", "D", True),
    ("6102", "61", "چک‌های امانی/تضمینی", "C", True),
    ("6103", "61", "کالای امانی نزد ما", "D", True),
    ("6104", "61", "کالای امانی نزد دیگران", "C", True),
    ("6105", "61", "تعهدات قراردادی خرید", "D", True),
    ("6106", "61", "ضمانت‌نامه‌های بانکی", "D", True),
    ("6107", "61", "تعهدات ارزی صادراتی", "D", True),
]

ROLE_PERMISSIONS: dict[str, list[str]] = {
    "SYS_ADMIN": [
        "sys.user.manage", "sys.role.manage", "sys.setting.manage", "sys.audit.view",
        "sys.backup.run", "sys.device.manage", "fin.account.view", "bi.view.dashboard",
        "rpt.view", "prt.template.manage",
    ],
    "OWNER": [
        "bi.view.dashboard", "bi.view.profit", "bi.view.customer_profit", "bi.view.cashflow",
        "fin.report.view", "trs.payment.approve", "sal.invoice.view", "rpt.view", "sys.audit.view",
    ],
    "FIN_MANAGER": [
        "fin.voucher.create", "fin.voucher.post", "fin.voucher.approve", "fin.voucher.reverse",
        "fin.account.view", "fin.report.view", "fin.baddebt.approve", "trs.payment.create",
        "trs.payment.approve", "bnk.recon.view", "bnk.recon.approve", "imp.batch.upload",
        "imp.batch.post", "imp.batch.rollback", "sys.period.close", "sys.period.reopen",
        "inv.count.approve", "bi.view.profit", "sal.credit.override", "rpt.view", "rpt.export",
    ],
    "CHIEF_ACCOUNTANT": [
        "fin.account.manage", "fin.voucher.create", "fin.voucher.post", "fin.voucher.approve",
        "fin.voucher.reverse", "fin.voucher.adjust", "fin.report.view", "fin.account.view",
        "imp.batch.upload", "imp.batch.review", "imp.batch.post", "imp.batch.rollback",
        "imp.template.manage", "imp.rule.manage", "bnk.recon.view", "inv.count.approve",
        "bi.view.profit", "rpt.view", "rpt.export",
    ],
    "ACCOUNTANT": [
        "fin.voucher.create", "fin.report.view", "fin.account.view", "imp.batch.upload",
        "imp.batch.review", "bnk.recon.view", "trs.receipt.create", "bi.view.dashboard",
        "rpt.view",
    ],
    "AUDITOR": [
        "fin.report.view", "fin.account.view", "bi.view.profit", "bi.view.customer_profit",
        "sys.audit.view", "rpt.view", "rpt.export", "wb.ticket.create", "inv.lot.view",
    ],
    "SALES_MANAGER": [
        "sal.invoice.view", "sal.invoice.create", "sal.invoice.post", "sal.price.manage",
        "sal.deduction.manage", "sal.discount.grant", "sal.credit.override", "sal.return.create",
        "crm.customer.view", "crm.customer.create", "crm.customer.manage", "crm.credit.view",
        "bi.view.dashboard", "rpt.view",
    ],
    "SALES": [
        "sal.invoice.view", "sal.invoice.create", "sal.price.manage", "crm.customer.create",
        "crm.customer.view", "crm.interaction.log", "bi.view.dashboard",
    ],
    "PURCHASING": [
        "pur.invoice.create", "pur.invoice.post", "pur.contract.manage", "pur.order.create",
        "wb.ticket.price", "crm.customer.create", "crm.customer.view", "rpt.view",
    ],
    "WB_OPERATOR": [
        "wb.ticket.create", "wb.ticket.weigh", "wb.ticket.print",
    ],
    "WB_SUPERVISOR": [
        "wb.ticket.create", "wb.ticket.weigh", "wb.ticket.price", "wb.ticket.approve",
        "wb.ticket.post", "wb.ticket.void", "wb.manual_weight", "wb.override_loss",
        "wb.cash.pay", "wb.ticket.print", "trs.receipt.create",
    ],
    "WAREHOUSE": [
        "inv.move.create", "inv.move.post", "inv.transfer", "inv.count.create",
        "inv.waste.record", "inv.lot.view", "inv.cold.manage",
    ],
    "PRODUCTION": [
        "prd.workorder.create", "prd.sort.record", "prd.pack.record", "prd.close",
        "prd.waste.record", "inv.move.create",
    ],
    "TREASURY": [
        "trs.receipt.create", "trs.payment.create", "trs.cheque.create", "trs.cheque.settle",
        "trs.cash.count", "bnk.recon.view", "rpt.view",
    ],
    "HR": [
        "hr.employee.manage", "hr.payroll.run", "hr.salary.view",
    ],
    "VIEWER": [
        "bi.view.dashboard", "rpt.view",
    ],
}


def escape(value: str) -> str:
    return value.replace("'", "''")


def gen_accounts() -> str:
    lines = [
        "-- تولیدشده با tools/gen_seed.py — ویرایش دستی نکنید",
        "-- منبع: docs/accounting/chart-of-accounts.md",
        "BEGIN;",
        "",
    ]
    for code, parent, name, nature, postable in ACCOUNTS:
        level = {1: 1, 2: 2, 3: 3, 5: 4}.get(len(code), 2)
        group = int(code[0])
        parent_expr = f"(SELECT id FROM fin_account WHERE code = '{parent}')" if parent else "NULL"
        lines.append(
            "INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)\n"
            f"VALUES (gen_random_uuid(), '{code}', {parent_expr}, {level}, {group}, '{nature}', "
            f"'{escape(name)}', {str(postable).lower()}, true);"
        )
    lines += ["", "COMMIT;", ""]
    return "\n".join(lines)


def gen_roles() -> str:
    lines = [
        "-- تولیدشده با tools/gen_seed.py — ویرایش دستی نکنید",
        "-- منبع: docs/security/roles-matrix.md",
        "BEGIN;",
        "",
    ]
    for role, permissions in ROLE_PERMISSIONS.items():
        lines.append(
            "INSERT INTO sys_role (id, code, name_fa, is_system) "
            f"VALUES (gen_random_uuid(), '{role}', '{role}', true);"
        )
        for perm in permissions:
            lines.append(
                "INSERT INTO sys_role_permission (role_id, permission) "
                f"SELECT id, '{perm}' FROM sys_role WHERE code = '{role}';"
            )
        lines.append("")
    lines += ["COMMIT;", ""]
    return "\n".join(lines)


def main() -> None:
    SEED.mkdir(parents=True, exist_ok=True)
    (SEED / "chart_of_accounts.sql").write_text(gen_accounts(), encoding="utf-8")
    (SEED / "roles.sql").write_text(gen_roles(), encoding="utf-8")
    print(f"✓ {len(ACCOUNTS)} حساب و {len(ROLE_PERMISSIONS)} نقش تولید شد.")


if __name__ == "__main__":
    main()
