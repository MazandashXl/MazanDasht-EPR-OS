-- تولیدشده با tools/gen_seed.py — ویرایش دستی نکنید
-- منبع: docs/security/roles-matrix.md
BEGIN;

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'SYS_ADMIN', 'SYS_ADMIN', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sys.user.manage' FROM sys_role WHERE code = 'SYS_ADMIN';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sys.role.manage' FROM sys_role WHERE code = 'SYS_ADMIN';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sys.setting.manage' FROM sys_role WHERE code = 'SYS_ADMIN';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sys.audit.view' FROM sys_role WHERE code = 'SYS_ADMIN';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sys.backup.run' FROM sys_role WHERE code = 'SYS_ADMIN';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sys.device.manage' FROM sys_role WHERE code = 'SYS_ADMIN';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.account.view' FROM sys_role WHERE code = 'SYS_ADMIN';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.dashboard' FROM sys_role WHERE code = 'SYS_ADMIN';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.view' FROM sys_role WHERE code = 'SYS_ADMIN';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'prt.template.manage' FROM sys_role WHERE code = 'SYS_ADMIN';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'OWNER', 'OWNER', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.dashboard' FROM sys_role WHERE code = 'OWNER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.profit' FROM sys_role WHERE code = 'OWNER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.customer_profit' FROM sys_role WHERE code = 'OWNER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.cashflow' FROM sys_role WHERE code = 'OWNER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.report.view' FROM sys_role WHERE code = 'OWNER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'trs.payment.approve' FROM sys_role WHERE code = 'OWNER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.invoice.view' FROM sys_role WHERE code = 'OWNER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.view' FROM sys_role WHERE code = 'OWNER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sys.audit.view' FROM sys_role WHERE code = 'OWNER';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'FIN_MANAGER', 'FIN_MANAGER', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.voucher.create' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.voucher.post' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.voucher.approve' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.voucher.reverse' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.account.view' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.report.view' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.baddebt.approve' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'trs.payment.create' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'trs.payment.approve' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bnk.recon.view' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bnk.recon.approve' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'imp.batch.upload' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'imp.batch.post' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'imp.batch.rollback' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sys.period.close' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sys.period.reopen' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'inv.count.approve' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.profit' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.credit.override' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.view' FROM sys_role WHERE code = 'FIN_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.export' FROM sys_role WHERE code = 'FIN_MANAGER';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'CHIEF_ACCOUNTANT', 'CHIEF_ACCOUNTANT', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.account.manage' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.voucher.create' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.voucher.post' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.voucher.approve' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.voucher.reverse' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.voucher.adjust' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.report.view' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.account.view' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'imp.batch.upload' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'imp.batch.review' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'imp.batch.post' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'imp.batch.rollback' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'imp.template.manage' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'imp.rule.manage' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bnk.recon.view' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'inv.count.approve' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.profit' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.view' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.export' FROM sys_role WHERE code = 'CHIEF_ACCOUNTANT';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'ACCOUNTANT', 'ACCOUNTANT', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.voucher.create' FROM sys_role WHERE code = 'ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.report.view' FROM sys_role WHERE code = 'ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.account.view' FROM sys_role WHERE code = 'ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'imp.batch.upload' FROM sys_role WHERE code = 'ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'imp.batch.review' FROM sys_role WHERE code = 'ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bnk.recon.view' FROM sys_role WHERE code = 'ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'trs.receipt.create' FROM sys_role WHERE code = 'ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.dashboard' FROM sys_role WHERE code = 'ACCOUNTANT';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.view' FROM sys_role WHERE code = 'ACCOUNTANT';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'AUDITOR', 'AUDITOR', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.report.view' FROM sys_role WHERE code = 'AUDITOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'fin.account.view' FROM sys_role WHERE code = 'AUDITOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.profit' FROM sys_role WHERE code = 'AUDITOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.customer_profit' FROM sys_role WHERE code = 'AUDITOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sys.audit.view' FROM sys_role WHERE code = 'AUDITOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.view' FROM sys_role WHERE code = 'AUDITOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.export' FROM sys_role WHERE code = 'AUDITOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.ticket.create' FROM sys_role WHERE code = 'AUDITOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'inv.lot.view' FROM sys_role WHERE code = 'AUDITOR';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'SALES_MANAGER', 'SALES_MANAGER', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.invoice.view' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.invoice.create' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.invoice.post' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.price.manage' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.deduction.manage' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.discount.grant' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.credit.override' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.return.create' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'crm.customer.view' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'crm.customer.create' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'crm.customer.manage' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'crm.credit.view' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.dashboard' FROM sys_role WHERE code = 'SALES_MANAGER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.view' FROM sys_role WHERE code = 'SALES_MANAGER';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'SALES', 'SALES', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.invoice.view' FROM sys_role WHERE code = 'SALES';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.invoice.create' FROM sys_role WHERE code = 'SALES';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'sal.price.manage' FROM sys_role WHERE code = 'SALES';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'crm.customer.create' FROM sys_role WHERE code = 'SALES';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'crm.customer.view' FROM sys_role WHERE code = 'SALES';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'crm.interaction.log' FROM sys_role WHERE code = 'SALES';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.dashboard' FROM sys_role WHERE code = 'SALES';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'PURCHASING', 'PURCHASING', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'pur.invoice.create' FROM sys_role WHERE code = 'PURCHASING';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'pur.invoice.post' FROM sys_role WHERE code = 'PURCHASING';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'pur.contract.manage' FROM sys_role WHERE code = 'PURCHASING';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'pur.order.create' FROM sys_role WHERE code = 'PURCHASING';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.ticket.price' FROM sys_role WHERE code = 'PURCHASING';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'crm.customer.create' FROM sys_role WHERE code = 'PURCHASING';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'crm.customer.view' FROM sys_role WHERE code = 'PURCHASING';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.view' FROM sys_role WHERE code = 'PURCHASING';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'WB_OPERATOR', 'WB_OPERATOR', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.ticket.create' FROM sys_role WHERE code = 'WB_OPERATOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.ticket.weigh' FROM sys_role WHERE code = 'WB_OPERATOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.ticket.print' FROM sys_role WHERE code = 'WB_OPERATOR';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'WB_SUPERVISOR', 'WB_SUPERVISOR', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.ticket.create' FROM sys_role WHERE code = 'WB_SUPERVISOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.ticket.weigh' FROM sys_role WHERE code = 'WB_SUPERVISOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.ticket.price' FROM sys_role WHERE code = 'WB_SUPERVISOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.ticket.approve' FROM sys_role WHERE code = 'WB_SUPERVISOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.ticket.post' FROM sys_role WHERE code = 'WB_SUPERVISOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.ticket.void' FROM sys_role WHERE code = 'WB_SUPERVISOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.manual_weight' FROM sys_role WHERE code = 'WB_SUPERVISOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.override_loss' FROM sys_role WHERE code = 'WB_SUPERVISOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.cash.pay' FROM sys_role WHERE code = 'WB_SUPERVISOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'wb.ticket.print' FROM sys_role WHERE code = 'WB_SUPERVISOR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'trs.receipt.create' FROM sys_role WHERE code = 'WB_SUPERVISOR';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'WAREHOUSE', 'WAREHOUSE', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'inv.move.create' FROM sys_role WHERE code = 'WAREHOUSE';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'inv.move.post' FROM sys_role WHERE code = 'WAREHOUSE';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'inv.transfer' FROM sys_role WHERE code = 'WAREHOUSE';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'inv.count.create' FROM sys_role WHERE code = 'WAREHOUSE';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'inv.waste.record' FROM sys_role WHERE code = 'WAREHOUSE';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'inv.lot.view' FROM sys_role WHERE code = 'WAREHOUSE';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'inv.cold.manage' FROM sys_role WHERE code = 'WAREHOUSE';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'PRODUCTION', 'PRODUCTION', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'prd.workorder.create' FROM sys_role WHERE code = 'PRODUCTION';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'prd.sort.record' FROM sys_role WHERE code = 'PRODUCTION';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'prd.pack.record' FROM sys_role WHERE code = 'PRODUCTION';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'prd.close' FROM sys_role WHERE code = 'PRODUCTION';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'prd.waste.record' FROM sys_role WHERE code = 'PRODUCTION';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'inv.move.create' FROM sys_role WHERE code = 'PRODUCTION';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'TREASURY', 'TREASURY', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'trs.receipt.create' FROM sys_role WHERE code = 'TREASURY';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'trs.payment.create' FROM sys_role WHERE code = 'TREASURY';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'trs.cheque.create' FROM sys_role WHERE code = 'TREASURY';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'trs.cheque.settle' FROM sys_role WHERE code = 'TREASURY';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'trs.cash.count' FROM sys_role WHERE code = 'TREASURY';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bnk.recon.view' FROM sys_role WHERE code = 'TREASURY';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.view' FROM sys_role WHERE code = 'TREASURY';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'HR', 'HR', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'hr.employee.manage' FROM sys_role WHERE code = 'HR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'hr.payroll.run' FROM sys_role WHERE code = 'HR';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'hr.salary.view' FROM sys_role WHERE code = 'HR';

INSERT INTO sys_role (id, code, name_fa, is_system) VALUES (gen_random_uuid(), 'VIEWER', 'VIEWER', true);
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'bi.view.dashboard' FROM sys_role WHERE code = 'VIEWER';
INSERT INTO sys_role_permission (role_id, permission) SELECT id, 'rpt.view' FROM sys_role WHERE code = 'VIEWER';

COMMIT;
