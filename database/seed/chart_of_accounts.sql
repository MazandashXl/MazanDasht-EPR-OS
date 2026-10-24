-- تولیدشده با tools/gen_seed.py — ویرایش دستی نکنید
-- منبع: docs/accounting/chart-of-accounts.md
BEGIN;

INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1', NULL, 1, 1, 'D', 'دارایی‌ها', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2', NULL, 1, 2, 'C', 'بدهی‌ها', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '3', NULL, 1, 3, 'C', 'سرمایه', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '4', NULL, 1, 4, 'C', 'درآمدها', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5', NULL, 1, 5, 'D', 'هزینه‌ها', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '6', NULL, 1, 6, 'D', 'حساب‌های انتظامی', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11', (SELECT id FROM fin_account WHERE code = '1'), 2, 1, 'D', 'دارایی‌های جاری', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1101', (SELECT id FROM fin_account WHERE code = '11'), 2, 1, 'D', 'صندوق', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11011', (SELECT id FROM fin_account WHERE code = '1101'), 4, 1, 'D', 'صندوق مرکزی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11012', (SELECT id FROM fin_account WHERE code = '1101'), 4, 1, 'D', 'تنخواه خرید', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11013', (SELECT id FROM fin_account WHERE code = '1101'), 4, 1, 'D', 'صندوق باسکول', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1102', (SELECT id FROM fin_account WHERE code = '11'), 2, 1, 'D', 'بانک‌ها', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11021', (SELECT id FROM fin_account WHERE code = '1102'), 4, 1, 'D', 'بانک ملت — جاری اصلی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11022', (SELECT id FROM fin_account WHERE code = '1102'), 4, 1, 'D', 'بانک ملی — جاری', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11023', (SELECT id FROM fin_account WHERE code = '1102'), 4, 1, 'D', 'بانک تجارت — جاری', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11024', (SELECT id FROM fin_account WHERE code = '1102'), 4, 1, 'D', 'بانک صادرات — جاری', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11025', (SELECT id FROM fin_account WHERE code = '1102'), 4, 1, 'D', 'بانک سپه — جاری', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11026', (SELECT id FROM fin_account WHERE code = '1102'), 4, 1, 'D', 'بانک پاسارگاد — جاری', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11027', (SELECT id FROM fin_account WHERE code = '1102'), 4, 1, 'D', 'حساب ارزی — دلار', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11028', (SELECT id FROM fin_account WHERE code = '1102'), 4, 1, 'D', 'حساب ارزی — یورو', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1103', (SELECT id FROM fin_account WHERE code = '11'), 2, 1, 'D', 'حساب‌های دریافتنی تجاری', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11031', (SELECT id FROM fin_account WHERE code = '1103'), 4, 1, 'D', 'دریافتنی از بارفروشان', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11032', (SELECT id FROM fin_account WHERE code = '1103'), 4, 1, 'D', 'دریافتنی از عمده‌فروشان', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11033', (SELECT id FROM fin_account WHERE code = '1103'), 4, 1, 'D', 'دریافتنی صادراتی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11034', (SELECT id FROM fin_account WHERE code = '1103'), 4, 1, 'D', 'دریافتنی متفرقه', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1104', (SELECT id FROM fin_account WHERE code = '11'), 2, 1, 'D', 'اسناد دریافتنی (چک)', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11041', (SELECT id FROM fin_account WHERE code = '1104'), 4, 1, 'D', 'چک‌های در جریان وصول', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11042', (SELECT id FROM fin_account WHERE code = '1104'), 4, 1, 'D', 'چک‌های نزد صندوق', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11043', (SELECT id FROM fin_account WHERE code = '1104'), 4, 1, 'D', 'چک‌های تضمینی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1105', (SELECT id FROM fin_account WHERE code = '11'), 2, 1, 'D', 'پیش‌پرداخت‌ها', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11051', (SELECT id FROM fin_account WHERE code = '1105'), 4, 1, 'D', 'پیش‌پرداخت به باغداران', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11052', (SELECT id FROM fin_account WHERE code = '1105'), 4, 1, 'D', 'پیش‌پرداخت به تأمین‌کنندگان', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1106', (SELECT id FROM fin_account WHERE code = '11'), 2, 1, 'D', 'حساب واسط تسویه (شناور)', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1107', (SELECT id FROM fin_account WHERE code = '11'), 2, 1, 'D', 'اعتبار مالیات بر ارزش افزوده', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11071', (SELECT id FROM fin_account WHERE code = '1107'), 4, 1, 'D', 'مالیات خرید (اعتبار)', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1108', (SELECT id FROM fin_account WHERE code = '11'), 2, 1, 'D', 'سایر دریافتنی‌ها', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11081', (SELECT id FROM fin_account WHERE code = '1108'), 4, 1, 'D', 'علی‌الحساب کارکنان', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11082', (SELECT id FROM fin_account WHERE code = '1108'), 4, 1, 'D', 'مساعده و وام پرسنل', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '11083', (SELECT id FROM fin_account WHERE code = '1108'), 4, 1, 'D', 'سپرده‌های پرداختی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '12', (SELECT id FROM fin_account WHERE code = '1'), 2, 1, 'D', 'موجودی‌ها', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1201', (SELECT id FROM fin_account WHERE code = '12'), 2, 1, 'D', 'موجودی میوه در سردخانه', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1202', (SELECT id FROM fin_account WHERE code = '12'), 2, 1, 'D', 'موجودی میوه در جریان سورت', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1203', (SELECT id FROM fin_account WHERE code = '12'), 2, 1, 'D', 'موجودی آماده فروش', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1204', (SELECT id FROM fin_account WHERE code = '12'), 2, 1, 'D', 'کارتن و مواد بسته‌بندی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1205', (SELECT id FROM fin_account WHERE code = '12'), 2, 1, 'D', 'سبد و پالت', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1206', (SELECT id FROM fin_account WHERE code = '12'), 2, 1, 'D', 'ضایعات قابل فروش', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1207', (SELECT id FROM fin_account WHERE code = '12'), 2, 1, 'D', 'کالای در راه', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '13', (SELECT id FROM fin_account WHERE code = '1'), 2, 1, 'D', 'دارایی‌های ثابت', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1301', (SELECT id FROM fin_account WHERE code = '13'), 2, 1, 'D', 'زمین', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1302', (SELECT id FROM fin_account WHERE code = '13'), 2, 1, 'D', 'ساختمان و انبار', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1303', (SELECT id FROM fin_account WHERE code = '13'), 2, 1, 'D', 'سردخانه و تجهیزات سرمایش', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1304', (SELECT id FROM fin_account WHERE code = '13'), 2, 1, 'D', 'خط سورت و بسته‌بندی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1305', (SELECT id FROM fin_account WHERE code = '13'), 2, 1, 'D', 'خودرو و لیفتراک', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1306', (SELECT id FROM fin_account WHERE code = '13'), 2, 1, 'D', 'اثاثه و تجهیزات اداری', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1307', (SELECT id FROM fin_account WHERE code = '13'), 2, 1, 'C', 'استهلاک انباشته', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '14', (SELECT id FROM fin_account WHERE code = '1'), 2, 1, 'D', 'دارایی‌های نامشهود', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1401', (SELECT id FROM fin_account WHERE code = '14'), 2, 1, 'D', 'نرم‌افزار و لایسنس', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '1402', (SELECT id FROM fin_account WHERE code = '14'), 2, 1, 'D', 'حقوق و امتیاز', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '15', (SELECT id FROM fin_account WHERE code = '1'), 2, 1, 'D', 'دارایی در جریان تکمیل', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '21', (SELECT id FROM fin_account WHERE code = '2'), 2, 2, 'C', 'بدهی‌های جاری', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2101', (SELECT id FROM fin_account WHERE code = '21'), 2, 2, 'C', 'حساب‌های پرداختنی — باغداران', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2102', (SELECT id FROM fin_account WHERE code = '21'), 2, 2, 'C', 'حساب‌های پرداختنی — تأمین‌کنندگان', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2103', (SELECT id FROM fin_account WHERE code = '21'), 2, 2, 'C', 'اسناد پرداختنی (چک)', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '21031', (SELECT id FROM fin_account WHERE code = '2103'), 4, 2, 'C', 'چک‌های پرداختنی سرسید', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '21032', (SELECT id FROM fin_account WHERE code = '2103'), 4, 2, 'C', 'چک‌های امانی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2104', (SELECT id FROM fin_account WHERE code = '21'), 2, 2, 'C', 'حقوق و دستمزد پرداختنی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2105', (SELECT id FROM fin_account WHERE code = '21'), 2, 2, 'C', 'بیمه تأمین اجتماعی پرداختنی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2106', (SELECT id FROM fin_account WHERE code = '21'), 2, 2, 'C', 'مالیات و عوارض پرداختنی', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '21061', (SELECT id FROM fin_account WHERE code = '2106'), 4, 2, 'C', 'مالیات بر ارزش افزوده فروش', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '21062', (SELECT id FROM fin_account WHERE code = '2106'), 4, 2, 'C', 'مالیات بر حقوق', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '21063', (SELECT id FROM fin_account WHERE code = '2106'), 4, 2, 'C', 'عوارض صنفی/شهرداری', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2107', (SELECT id FROM fin_account WHERE code = '21'), 2, 2, 'C', 'پیش‌دریافت از مشتریان', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2108', (SELECT id FROM fin_account WHERE code = '21'), 2, 2, 'C', 'صافی و کسورات پرداختنی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2109', (SELECT id FROM fin_account WHERE code = '21'), 2, 2, 'C', 'هزینه‌های شناسایی‌شده پرداخت‌نشده', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '22', (SELECT id FROM fin_account WHERE code = '2'), 2, 2, 'C', 'وام و تسهیلات', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2201', (SELECT id FROM fin_account WHERE code = '22'), 2, 2, 'C', 'وام کوتاه‌مدت', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2202', (SELECT id FROM fin_account WHERE code = '22'), 2, 2, 'C', 'وام بلندمدت', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '23', (SELECT id FROM fin_account WHERE code = '2'), 2, 2, 'C', 'بدهی بلندمدت و اجاره', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '2301', (SELECT id FROM fin_account WHERE code = '23'), 2, 2, 'C', 'اجاره پرداختنی بلندمدت', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '31', (SELECT id FROM fin_account WHERE code = '3'), 2, 3, 'C', 'سرمایه و اندوخته', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '3101', (SELECT id FROM fin_account WHERE code = '31'), 2, 3, 'C', 'سرمایه اولیه', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '3102', (SELECT id FROM fin_account WHERE code = '31'), 2, 3, 'C', 'سود (زیان) انباشته', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '3103', (SELECT id FROM fin_account WHERE code = '31'), 2, 3, 'D', 'برداشت مالک', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '3104', (SELECT id FROM fin_account WHERE code = '31'), 2, 3, 'C', 'اندوخته قانونی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '3199', (SELECT id FROM fin_account WHERE code = '31'), 2, 3, 'C', 'حساب بستن', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '41', (SELECT id FROM fin_account WHERE code = '4'), 2, 4, 'C', 'درآمدهای عملیاتی', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '4101', (SELECT id FROM fin_account WHERE code = '41'), 2, 4, 'C', 'فروش مرکبات درجه یک', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '4102', (SELECT id FROM fin_account WHERE code = '41'), 2, 4, 'C', 'فروش مرکبات درجه دو', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '4103', (SELECT id FROM fin_account WHERE code = '41'), 2, 4, 'C', 'فروش صنعتی و ضایعات', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '4104', (SELECT id FROM fin_account WHERE code = '41'), 2, 4, 'C', 'فروش صادراتی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '4105', (SELECT id FROM fin_account WHERE code = '41'), 2, 4, 'C', 'درآمد خدمات بسته‌بندی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '4106', (SELECT id FROM fin_account WHERE code = '41'), 2, 4, 'C', 'کرایه حمل دریافتنی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '4107', (SELECT id FROM fin_account WHERE code = '41'), 2, 4, 'D', 'تخفیف نقدی فروش', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '4108', (SELECT id FROM fin_account WHERE code = '41'), 2, 4, 'D', 'برگشت از فروش و کسورات (صافی)', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '4109', (SELECT id FROM fin_account WHERE code = '41'), 2, 4, 'C', 'درآمد متفرقه', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '51', (SELECT id FROM fin_account WHERE code = '5'), 2, 5, 'D', 'بهای تمام‌شده و هزینه‌های مستقیم', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5101', (SELECT id FROM fin_account WHERE code = '51'), 2, 5, 'D', 'بهای تمام‌شده میوه فروش‌رفته', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5102', (SELECT id FROM fin_account WHERE code = '51'), 2, 5, 'D', 'دستمزد سورت و بسته‌بندی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5103', (SELECT id FROM fin_account WHERE code = '51'), 2, 5, 'D', 'کارتن و مواد بسته‌بندی مصرفی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5104', (SELECT id FROM fin_account WHERE code = '51'), 2, 5, 'D', 'ضایعات و افت غیرعادی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5105', (SELECT id FROM fin_account WHERE code = '51'), 2, 5, 'D', 'هزینه حمل فروش', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5106', (SELECT id FROM fin_account WHERE code = '51'), 2, 5, 'D', 'کمیسیون فروش', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5107', (SELECT id FROM fin_account WHERE code = '51'), 2, 5, 'D', 'بارگری و کارگر', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '52', (SELECT id FROM fin_account WHERE code = '5'), 2, 5, 'D', 'هزینه‌های عملیاتی', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5201', (SELECT id FROM fin_account WHERE code = '52'), 2, 5, 'D', 'حقوق و دستمزد', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5202', (SELECT id FROM fin_account WHERE code = '52'), 2, 5, 'D', 'بیمه سهم کارفرما', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5203', (SELECT id FROM fin_account WHERE code = '52'), 2, 5, 'D', 'برق', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5204', (SELECT id FROM fin_account WHERE code = '52'), 2, 5, 'D', 'آب و گاز', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5205', (SELECT id FROM fin_account WHERE code = '52'), 2, 5, 'D', 'سوخت خودرو و لیفتراک', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5206', (SELECT id FROM fin_account WHERE code = '52'), 2, 5, 'D', 'تعمیر و نگهداشت سردخانه', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5207', (SELECT id FROM fin_account WHERE code = '52'), 2, 5, 'D', 'تعمیر خودرو', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5208', (SELECT id FROM fin_account WHERE code = '52'), 2, 5, 'D', 'اجاره', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5209', (SELECT id FROM fin_account WHERE code = '52'), 2, 5, 'D', 'ملزومات و مصرفی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5210', (SELECT id FROM fin_account WHERE code = '52'), 2, 5, 'D', 'ارتباطات و اینترنت', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5211', (SELECT id FROM fin_account WHERE code = '52'), 2, 5, 'D', 'پذیرایی، سفر و مأموریت', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5212', (SELECT id FROM fin_account WHERE code = '52'), 2, 5, 'D', 'خدمات پیمانکاری', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '53', (SELECT id FROM fin_account WHERE code = '5'), 2, 5, 'D', 'هزینه‌های عمومی و اداری', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5301', (SELECT id FROM fin_account WHERE code = '53'), 2, 5, 'D', 'استهلاک دارایی‌ها', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5302', (SELECT id FROM fin_account WHERE code = '53'), 2, 5, 'D', 'کارمزد و هزینه بانکی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5303', (SELECT id FROM fin_account WHERE code = '53'), 2, 5, 'D', 'هزینه مالی و سود تسهیلات', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5304', (SELECT id FROM fin_account WHERE code = '53'), 2, 5, 'D', 'حق‌الوکاله و مشاوره', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5305', (SELECT id FROM fin_account WHERE code = '53'), 2, 5, 'D', 'تبلیغات و بازاریابی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5306', (SELECT id FROM fin_account WHERE code = '53'), 2, 5, 'D', 'حمل و نقل متفرقه', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5307', (SELECT id FROM fin_account WHERE code = '53'), 2, 5, 'D', 'جریمه، خسارت و کسورات', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5308', (SELECT id FROM fin_account WHERE code = '53'), 2, 5, 'D', 'کسری و مغایرت انبار', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5309', (SELECT id FROM fin_account WHERE code = '53'), 2, 5, 'D', 'سایر هزینه‌ها', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '54', (SELECT id FROM fin_account WHERE code = '5'), 2, 5, 'D', 'مالیات بر درآمد', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '5401', (SELECT id FROM fin_account WHERE code = '54'), 2, 5, 'D', 'مالیات بر درآمد', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '61', (SELECT id FROM fin_account WHERE code = '6'), 2, 6, 'D', 'حساب‌های انتظامی', false, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '6101', (SELECT id FROM fin_account WHERE code = '61'), 2, 6, 'D', 'چک‌های در جریان وصول', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '6102', (SELECT id FROM fin_account WHERE code = '61'), 2, 6, 'C', 'چک‌های امانی/تضمینی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '6103', (SELECT id FROM fin_account WHERE code = '61'), 2, 6, 'D', 'کالای امانی نزد ما', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '6104', (SELECT id FROM fin_account WHERE code = '61'), 2, 6, 'C', 'کالای امانی نزد دیگران', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '6105', (SELECT id FROM fin_account WHERE code = '61'), 2, 6, 'D', 'تعهدات قراردادی خرید', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '6106', (SELECT id FROM fin_account WHERE code = '61'), 2, 6, 'D', 'ضمانت‌نامه‌های بانکی', true, true);
INSERT INTO fin_account (id, code, parent_id, level, group_code, nature, name_fa, is_leaf, is_active)
VALUES (gen_random_uuid(), '6107', (SELECT id FROM fin_account WHERE code = '61'), 2, 6, 'D', 'تعهدات ارزی صادراتی', true, true);

COMMIT;
