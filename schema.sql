START TRANSACTION;
CREATE DATABASE project;
COMMIT;

USE project;

CREATE TABLE person (
    person_id		INT,
    f_name			VARCHAR(50),
    m_init			CHAR(1),
    l_name			VARCHAR(50),
    sex				CHAR(1),
    b_day			DATE,
    p_num			VARCHAR(20),
    street			VARCHAR(100),
    apt_no			VARCHAR(10),
    city			VARCHAR(50),
    state			VARCHAR(50),
    zip				VARCHAR(10),
    PRIMARY KEY (person_id)
);

CREATE TABLE company (
    company_name	VARCHAR(100),
    address			VARCHAR(255),
    comp_phone		VARCHAR(20),
    comp_email		VARCHAR(100),
    comp_website	VARCHAR(100),
    PRIMARY KEY (company_name)
);

CREATE TABLE hr_department (
    dep_id			INT,
    dep_name		VARCHAR(100),
    PRIMARY KEY (dep_id)
);

CREATE TABLE manufacturing_department (
    dep_id			INT,
    dep_name		VARCHAR(100),
    PRIMARY KEY (dep_id)
);

CREATE TABLE sales_department (
    dep_id			INT,
    dep_name		VARCHAR(100),
    PRIMARY KEY (dep_id)
);

CREATE TABLE marketing_sites (
    site_id			INT,
    site_name		VARCHAR(100),
    site_location	VARCHAR(255),
    operating_hours	VARCHAR(100),
    PRIMARY KEY (site_id)
);

CREATE TABLE employee (
    employee_id		INT,
    company_name	VARCHAR(100),
    title			VARCHAR(100),
    current_dep		ENUM('HR', 'Manufacturing', 'Sales'),
    curr_dep_start_date	DATE,
    curr_dep_end_date	DATE,
    supervisor_id	INT,
    all_dep			VARCHAR(255),
    emp_status		VARCHAR(50),
    PRIMARY KEY (employee_id, company_name),
    FOREIGN KEY (employee_id) 	REFERENCES person(person_id),
    FOREIGN KEY (company_name) 	REFERENCES company(company_name)
);
-- Add supervisor foreign key after table creation
ALTER TABLE employee
ADD FOREIGN KEY (supervisor_id) REFERENCES employee(employee_id);

CREATE TABLE marketing_site_employee (
    employee_id		INT,
    site_id			INT,
    salesmen		VARCHAR(255),
    customers		VARCHAR(255),
    products		VARCHAR(255),
    sale_time		VARCHAR(255),
    PRIMARY KEY (employee_id, site_id),
    FOREIGN KEY (employee_id)	REFERENCES employee(employee_id),
    FOREIGN KEY (site_id)		REFERENCES marketing_sites(site_id)
);

CREATE TABLE salary (
    transaction_num	INT,
    employee_id		INT,
    pay_date		DATE,
    amount			DECIMAL(10, 2),
    PRIMARY KEY (transaction_num, employee_id),
    FOREIGN KEY (employee_id)	REFERENCES employee(employee_id)
);

CREATE TABLE product (
    product_id		INT,
    product_name	VARCHAR(100),
    product_type	VARCHAR(50),
    inventory		INT,
    shipment_id		VARCHAR(50),
    list_price		DECIMAL(10, 2),
    size			VARCHAR(50),
    weight			DECIMAL(10, 2),
    style			VARCHAR(50),
    PRIMARY KEY (product_id)
);

CREATE TABLE parts (
    part_id			INT,
    part_name		VARCHAR(100),
    part_vendor		VARCHAR(100),
    part_price		DECIMAL(10, 2),
    weight			DECIMAL(10, 2),
    PRIMARY KEY (part_id)
);

CREATE TABLE vendors (
    vendor_id		INT,
    vendor_name		VARCHAR(100),
    vendor_addr		VARCHAR(255),
    acc_num			VARCHAR(50),
    purchase_URL	VARCHAR(255),
    credit_rating	INT,
    PRIMARY KEY (vendor_id)
);

CREATE TABLE job_position (
    job_id			INT,
    job_title		VARCHAR(100),
    job_disc		TEXT,
    date_posted		DATE,
    dep				ENUM('HR', 'Manufacturing', 'Sales'),
    PRIMARY KEY (job_id)
);

CREATE TABLE interview_panel (
    panel_id		INT,
    member_num		INT,
    PRIMARY KEY (panel_id)
);

CREATE TABLE interview_panel_members (
    panel_id		INT,
    member_id		INT,
    PRIMARY KEY (panel_id, member_id),
    FOREIGN KEY (panel_id)		REFERENCES interview_panel(panel_id)
);

CREATE TABLE interview (
    interview_id	INT,
    person_id		INT,
    job_id			INT,
    panel_id		INT,
    PRIMARY KEY (interview_id),
    FOREIGN KEY (person_id)		REFERENCES person(person_id),
    FOREIGN KEY (job_id)		REFERENCES job_position(job_id),
    FOREIGN KEY (panel_id)		REFERENCES interview_panel(panel_id)
);

CREATE TABLE interview_grade (
    interview_id	INT,
    PRIMARY KEY (interview_id),
    FOREIGN KEY (interview_id)	REFERENCES interview(interview_id)
);

CREATE TABLE grades (
    interview_id	INT,
    grades			INT,
    PRIMARY KEY (interview_id),
    FOREIGN KEY (interview_id)	REFERENCES interview(interview_id)
);

CREATE TABLE potential_employee (
    person_id		INT,
    emp_resume		TEXT,
    department		ENUM('HR', 'Manufacturing', 'Sales'),
    app_status		VARCHAR(50),
    PRIMARY KEY (person_id),
    FOREIGN KEY (person_id)		REFERENCES person(person_id)
);

CREATE TABLE customers (
    person_id		INT,
    sales_rep_id	INT,
    customer_email	VARCHAR(100),
    PRIMARY KEY (person_id),
    FOREIGN KEY (person_id)		REFERENCES person(person_id),
    FOREIGN KEY (sales_rep_id)	REFERENCES marketing_site_employee(employee_id)
);

-- Relationship tables for m:n relationships

CREATE TABLE sell_products (
    site_id			INT,
    customer_id		INT,
    sale_time		DATETIME,
    PRIMARY KEY (site_id, customer_id, sale_time),
    FOREIGN KEY (site_id)		REFERENCES marketing_sites(site_id),
    FOREIGN KEY (customer_id)	REFERENCES customers(person_id)
);

CREATE TABLE supplies (
    vendor_id		INT,
    part_id			INT,
    PRIMARY KEY (vendor_id, part_id),
    FOREIGN KEY (vendor_id)		REFERENCES vendors(vendor_id),
    FOREIGN KEY (part_id)		REFERENCES parts(part_id)
);

CREATE TABLE ship_to (
    product_id		INT,
    site_id			INT,
    PRIMARY KEY (product_id, site_id),
    FOREIGN KEY (product_id)	REFERENCES product(product_id),
    FOREIGN KEY (site_id)		REFERENCES marketing_sites(site_id)
);

CREATE TABLE product_parts (
    product_id		INT,
    part_id			INT,
    quantity		INT			DEFAULT 1,
    PRIMARY KEY (product_id, part_id),
    FOREIGN KEY (product_id)	REFERENCES product(product_id),
    FOREIGN KEY (part_id)		REFERENCES parts(part_id)
);

CREATE TABLE applies_for (
    application_id	INT			AUTO_INCREMENT,
    job_id			INT,
    person_id		INT			NULL,
    employee_id		INT			NULL,
    PRIMARY KEY (application_id),
    UNIQUE KEY (job_id, person_id, employee_id),
    FOREIGN KEY (job_id)		REFERENCES job_position(job_id),
    FOREIGN KEY (person_id)		REFERENCES potential_employee(person_id),
    FOREIGN KEY (employee_id)	REFERENCES employee(employee_id),
    CHECK (
        (person_id IS NULL AND employee_id IS NOT NULL) OR
        (person_id IS NOT NULL AND employee_id IS NULL)
    )
);


-- DML Statements

INSERT INTO person (person_id, f_name, m_init, l_name, sex, b_day, p_num, street, apt_no, city, state, zip)
VALUES 
(1, 'John', 'A', 'Smith', 'M', '1985-03-15', '555-123-4567', '123 Main St', '101', 'Austin', 'Texas', '78701'),
(2, 'Emma', 'B', 'Johnson', 'F', '1990-07-22', '555-234-5678', '456 Oak Ave', '202', 'Dallas', 'Texas', '75201'),
(3, 'Michael', 'C', 'Williams', 'M', '1982-11-30', '555-345-6789', '789 Pine Rd', NULL, 'Houston', 'Texas', '77002'),
(4, 'Sarah', 'D', 'Brown', 'F', '1988-05-18', '555-456-7890', '321 Cedar Ln', '303', 'San Antonio', 'Texas', '78205'),
(5, 'David', 'E', 'Jones', 'M', '1992-09-10', '555-567-8901', '654 Birch Dr', NULL, 'Austin', 'Texas', '78704'),
(6, 'Jennifer', 'F', 'Garcia', 'F', '1991-12-03', '555-678-9012', '987 Maple St', '404', 'Dallas', 'Texas', '75202'),
(7, 'Robert', 'G', 'Martinez', 'M', '1987-01-25', '555-789-0123', '159 Elm Way', NULL, 'Austin', 'Texas', '78703'),
(8, 'Lisa', 'H', 'Davis', 'F', '1993-08-14', '555-890-1234', '753 Walnut Pl', '505', 'Houston', 'Texas', '77005'),
(9, 'Kevin', 'I', 'Anderson', 'M', '1989-04-22', '555-901-2345', '246 Spruce Ln', NULL, 'Austin', 'Texas', '78702'),
(10, 'Michelle', 'J', 'Wilson', 'F', '1994-11-07', '555-012-3456', '357 Willow Ct', '606', 'Dallas', 'Texas', '75206'),
(11, 'Thomas', 'K', 'Lee', 'M', '1986-06-30', '555-123-4567', '468 Cypress Ave', NULL, 'Houston', 'Texas', '77006'),
(12, 'Hellen', NULL, 'Cole', 'F', '1992-05-10', '555-999-8888', '789 Test St', NULL, 'Austin', 'Texas', '78705');

INSERT INTO company (company_name, address, comp_phone, comp_email, comp_website)
VALUES 
('TechCorp', '100 Technology Pkwy, Austin, TX 78759', '512-555-1000', 'info@techcorp.com', 'www.techcorp.com');

INSERT INTO hr_department (dep_id, dep_name)
VALUES 
(101, 'Recruitment'),
(102, 'Employee Relations'),
(103, 'Payroll and Benefits');

INSERT INTO manufacturing_department (dep_id, dep_name)
VALUES 
(201, 'Production'),
(202, 'Quality Control'),
(203, 'Maintenance');

INSERT INTO sales_department (dep_id, dep_name)
VALUES 
(301, 'Direct Sales'),
(302, 'Account Management'),
(303, 'Customer Support');

INSERT INTO marketing_sites (site_id, site_name, site_location, operating_hours)
VALUES 
(1, 'Downtown Showroom', '123 Commerce St, Austin, TX 78701', '9:00-18:00 Mon-Fri'),
(2, 'North Mall Kiosk', '456 Shopping Center, Dallas, TX 75243', '10:00-21:00 Mon-Sat'),
(3, 'Airport Store', '789 Airport Blvd, Houston, TX 77210', '6:00-22:00 Daily');

INSERT INTO employee (employee_id, company_name, title, current_dep, curr_dep_start_date, curr_dep_end_date, supervisor_id, all_dep, emp_status)
VALUES 
(1, 'TechCorp', 'HR Director', 'HR', '2020-01-15', NULL, NULL, 'HR', 'Active'),
(2, 'TechCorp', 'Sales Representative', 'Sales', '2021-03-10', NULL, 1, 'Sales', 'Active'),
(3, 'TechCorp', 'Production Supervisor', 'Manufacturing', '2019-06-22', NULL, 1, 'Manufacturing,Sales,HR', 'Active'),
(4, 'TechCorp', 'Quality Control Specialist', 'Manufacturing', '2022-02-14', NULL, 3, 'Manufacturing', 'Active'),
(5, 'TechCorp', 'Sales Manager', 'Sales', '2020-09-05', NULL, 1, 'HR,Manufacturing,Sales', 'Active'),
(6, 'TechCorp', 'HR Specialist', 'HR', '2023-01-08', NULL, 1, 'HR', 'Active'),
(7, 'TechCorp', 'Manufacturing Technician', 'Manufacturing', '2021-11-15', NULL, 3, 'Manufacturing', 'Active'),
(8, 'TechCorp', 'Account Executive', 'Sales', '2022-07-20', NULL, 5, 'Sales', 'Active');

INSERT INTO marketing_site_employee (employee_id, site_id, salesmen, customers, products, sale_time)
VALUES 
(2, 1, 'Emma Johnson', 'Various retail clients', 'Tech products A, B, C', 'Weekdays'),
(5, 2, 'David Jones', 'Mall visitors, walk-ins', 'Products X, Y, Z', 'Weekends'),
(8, 3, 'Lisa Davis', 'Airport travelers', 'Travel accessories, gadgets', 'All week');

INSERT INTO salary (transaction_num, employee_id, pay_date, amount)
VALUES 
(10001, 1, '2025-03-31', 6500.00),
(10002, 2, '2025-03-31', 3500.00),
(10003, 3, '2025-03-31', 4500.00),
(10004, 4, '2025-03-31', 3800.00),
(10005, 5, '2025-03-31', 5200.00),
(10006, 6, '2025-03-31', 4000.00),
(10007, 7, '2025-03-31', 3600.00),
(10008, 8, '2025-03-31', 4200.00),
(10009, 1, '2025-04-30', 6500.00),
(10010, 2, '2025-04-30', 3500.00),
(10011, 3, '2025-04-30', 4500.00),
(10012, 4, '2025-04-30', 3800.00),
(10013, 5, '2025-04-30', 5200.00),
(10014, 6, '2025-04-30', 4000.00),
(10015, 7, '2025-04-30', 3600.00),
(10016, 8, '2025-04-30', 4200.00);

INSERT INTO product (product_id, product_name, product_type, inventory, shipment_id, list_price, size, weight, style)
VALUES 
(101, 'SmartPhone X', 'Electronics', 50, 'SHP-1001', 799.99, '6 inches', 0.35, 'Modern'),
(102, 'Laptop Pro', 'Electronics', 25, 'SHP-1002', 1299.99, '15 inches', 2.5, 'Professional'),
(103, 'Smart Watch', 'Wearable', 100, 'SHP-1003', 299.99, '1.5 inches', 0.1, 'Sporty'),
(104, 'Wireless Earbuds', 'Audio', 75, 'SHP-1004', 149.99, 'Small', 0.02, 'Minimalist'),
(105, 'Bluetooth Speaker', 'Audio', 40, 'SHP-1005', 89.99, 'Medium', 0.5, 'Portable'),
(106, 'Tablet Plus', 'Electronics', 35, 'SHP-1006', 499.99, '10 inches', 0.75, 'Slim'),
(107, 'Smart Home Hub', 'Smart Home', 60, 'SHP-1007', 199.99, 'Compact', 0.3, 'Modern');

INSERT INTO parts (part_id, part_name, part_vendor, part_price, weight)
VALUES 
(1001, 'LCD Screen', 'DisplayTech', 120.00, 0.2),
(1002, 'Battery Pack', 'PowerCells', 45.00, 0.1),
(1003, 'CPU Chip', 'ProcessorTech', 85.00, 0.05),
(1004, 'Speaker Unit', 'AudioParts', 15.00, 0.08),
(1005, 'Camera Module', 'OpticsInc', 35.00, 0.04),
(1006, 'Memory Chip', 'MemoryTech', 25.00, 0.02),
(1007, 'Touchscreen Panel', 'TouchTech', 65.00, 0.15),
(1008, 'Cup', 'PlasticWare', 2.50, 1.5),
(1009, 'Cup', 'GlassWorks', 5.00, 3.5),
(1010, 'Cup', 'PaperGoods', 1.50, 0.5);

INSERT INTO vendors (vendor_id, vendor_name, vendor_addr, acc_num, purchase_URL, credit_rating)
VALUES 
(501, 'DisplayTech', '100 Display Rd, San Jose, CA 95123', 'ACC-5001', 'www.displaytech.com/purchase', 95),
(502, 'PowerCells', '200 Battery Ave, Phoenix, AZ 85001', 'ACC-5002', 'www.powercells.com/order', 88),
(503, 'ProcessorTech', '300 Silicon St, Austin, TX 78758', 'ACC-5003', 'www.processortech.com/buy', 92),
(504, 'AudioParts', '400 Sound Blvd, Nashville, TN 37203', 'ACC-5004', 'www.audioparts.com/catalog', 85),
(505, 'OpticsInc', '500 Lens Way, Rochester, NY 14604', 'ACC-5005', 'www.opticsinc.com/shop', 90),
(506, 'MemoryTech', '600 RAM Drive, San Jose, CA 95124', 'ACC-5006', 'www.memorytech.com/order', 93),
(507, 'TouchTech', '700 Touch St, Seattle, WA 98101', 'ACC-5007', 'www.touchtech.com/buy', 87),
(508, 'PlasticWare', '800 Plastic Lane, Dallas, TX 75210', 'ACC-5008', 'www.plasticware.com/buy', 82),
(509, 'GlassWorks', '900 Glass Ave, Houston, TX 77008', 'ACC-5009', 'www.glassworks.com/shop', 78),
(510, 'PaperGoods', '1000 Paper St, Austin, TX 78712', 'ACC-5010', 'www.papergoods.com/order', 86);

INSERT INTO job_position (job_id, job_title, job_disc, date_posted, dep)
VALUES 
(11111, 'Senior HR Manager', 'Lead HR department operations', '2011-01-15', 'HR'),
(12345, 'Senior Manufacturing Engineer', 'Advanced engineering role', '2025-04-01', 'Manufacturing'),
(2001, 'Senior HR Specialist', 'Responsible for recruitment and employee relations', '2025-04-01', 'HR'),
(2002, 'Manufacturing Technician II', 'Assembly and quality control of electronic devices', '2025-04-05', 'Manufacturing'),
(2003, 'Senior Sales Representative', 'Promote and sell company products to enterprise customers', '2025-04-10', 'Sales'),
(2004, 'Production Manager', 'Oversee manufacturing processes and staff', '2025-03-01', 'Manufacturing'),
(2005, 'Sales Support Specialist', 'Provide customer support and sales assistance', '2011-01-20', 'Sales'),
(2006, 'HR Assistant', 'Support HR operations', '2011-02-10', 'HR');

INSERT INTO interview_panel (panel_id, member_num)
VALUES 
(301, 3),
(302, 2),
(303, 4),
(304, 3);

INSERT INTO interview_panel_members (panel_id, member_id)
VALUES 
(301, 1),
(301, 3),
(301, 5),
(302, 2),
(302, 5),
(303, 1),
(303, 3),
(303, 4),
(303, 7),
(304, 5),
(304, 6),
(304, 8);

INSERT INTO potential_employee (person_id, emp_resume, department, app_status)
VALUES 
(9, 'Experienced HR professional with 5 years in talent acquisition and employee relations.', 'HR', 'Interview Scheduled'),
(10, 'Manufacturing engineer with expertise in electronics production and quality control.', 'Manufacturing', 'In Review'),
(11, 'Sales professional with proven track record in B2B technology sales.', 'Sales', 'Offer Extended'),
(12, 'HR expert with management experience', 'HR', 'Interview Scheduled');

INSERT INTO interview (interview_id, person_id, job_id, panel_id)
VALUES 
(401, 9, 2001, 301),
(402, 10, 2002, 303),
(403, 11, 2003, 304),
(404, 12, 11111, 301);

INSERT INTO interview_grade (interview_id)
VALUES 
(401),
(402),
(403),
(404);

INSERT INTO grades (interview_id, grades)
VALUES 
(401, 88),
(402, 85),
(403, 92),
(404, 90);

INSERT INTO customers (person_id, sales_rep_id, customer_email)
VALUES 
(9, 2, 'kevin.anderson@email.com'),
(10, 8, 'michelle.wilson@email.com'),
(11, 5, 'thomas.lee@email.com');

INSERT INTO sell_products (site_id, customer_id, sale_time)
VALUES 
(1, 9, '2025-04-15 10:30:00'),
(2, 10, '2025-04-16 14:20:00'),
(3, 11, '2025-04-17 09:45:00'),
(1, 9, '2011-02-15 11:00:00'),
(1, 10, '2011-03-10 15:30:00'),
(2, 11, '2011-04-05 16:45:00');

INSERT INTO supplies (vendor_id, part_id)
VALUES 
(501, 1001),
(502, 1002),
(503, 1003),
(504, 1004),
(505, 1005),
(506, 1006),
(507, 1007),
(508, 1008),
(509, 1009),
(510, 1010);

INSERT INTO ship_to (product_id, site_id)
VALUES 
(101, 1),
(102, 1),
(103, 2),
(104, 2),
(105, 1),
(106, 3),
(107, 3);

INSERT INTO product_parts (product_id, part_id, quantity)
VALUES 
(101, 1001, 1),  -- SmartPhone has LCD Screen
(101, 1002, 1),  -- SmartPhone has Battery
(101, 1003, 1),  -- SmartPhone has CPU
(101, 1004, 2),  -- SmartPhone has 2 speakers
(101, 1005, 2),  -- SmartPhone has 2 cameras
(101, 1006, 1),  -- SmartPhone has Memory
(102, 1001, 1),  -- Laptop has LCD Screen 
(102, 1002, 1),  -- Laptop has Battery
(102, 1003, 1),  -- Laptop has CPU
(102, 1004, 4),  -- Laptop has 4 speakers
(102, 1006, 2),  -- Laptop has 2 Memory chips
(103, 1001, 1),  -- Smart Watch has LCD Screen
(103, 1002, 1),  -- Smart Watch has Battery
(104, 1002, 1),  -- Earbuds have Battery
(104, 1004, 2),  -- Earbuds have 2 speakers
(105, 1002, 1),  -- Speaker has Battery
(105, 1004, 1);  -- Speaker has Speaker unit

INSERT INTO applies_for (job_id, person_id, employee_id)
VALUES 
(2001, 9, NULL),
(2002, 10, NULL),
(2003, 11, NULL),
(11111, 12, NULL),
(12345, NULL, 7),
(2005, NULL, 2);

-- views

-- View1: Average monthly salary for each employee since they joined
CREATE OR REPLACE VIEW view1_avg_monthly_salary AS
SELECT e.employee_id, CONCAT(p.f_name, ' ', p.l_name) AS employee_name, AVG(s.amount) AS avg_monthly_salary, MIN(s.pay_date) AS first_pay_date, COUNT(s.transaction_num) AS payment_count
  FROM employee e
  JOIN person p ON e.employee_id = p.person_id
  JOIN salary s ON e.employee_id = s.employee_id
 GROUP BY e.employee_id, p.f_name, p.l_name;

-- View2: Number of interview rounds each interviewee passes for each job position
CREATE OR REPLACE VIEW view2_interview_rounds AS
SELECT i.person_id, CONCAT(p.f_name, ' ', p.l_name) AS interviewee_name, i.job_id, j.job_title, COUNT(i.interview_id) AS interview_rounds, MAX(g.grades) AS best_grade
  FROM interview i
  JOIN person p ON i.person_id = p.person_id
  JOIN job_position j ON i.job_id = j.job_id
  LEFT JOIN grades g ON i.interview_id = g.interview_id
 GROUP BY i.person_id, p.f_name, p.l_name, i.job_id, j.job_title;

-- View3: Number of items of each product type sold
CREATE OR REPLACE VIEW view3_product_type_sales AS
SELECT p.product_type, COUNT(DISTINCT sp.customer_id) AS customers_count, COUNT(sp.site_id) AS sales_count
  FROM product p
  JOIN ship_to st ON p.product_id = st.product_id
  JOIN sell_products sp ON st.site_id = sp.site_id
 GROUP BY p.product_type;

-- View4: Part purchase cost for each product (using product_parts table)
CREATE OR REPLACE VIEW view4_product_part_cost AS
SELECT p.product_id, p.product_name, SUM(pt.part_price * pp.quantity) AS total_part_cost, SUM(pp.quantity) AS parts_count
  FROM product p
  JOIN product_parts pp ON p.product_id = pp.product_id
  JOIN parts pt ON pp.part_id = pt.part_id
 GROUP BY p.product_id, p.product_name;

-- querries

-- Query 1: Interviewers who participate in interviews with "Hellen Cole" for job "11111"
SELECT DISTINCT ipm.member_id AS interviewer_id, CONCAT(p.f_name, ' ', p.l_name) AS interviewer_name
  FROM interview i
  JOIN person interviewee ON i.person_id = interviewee.person_id
  JOIN interview_panel_members ipm ON i.panel_id = ipm.panel_id
  JOIN person p ON ipm.member_id = p.person_id
 WHERE interviewee.f_name = 'Hellen' 
   AND interviewee.l_name = 'Cole'
   AND i.job_id = 11111;

-- Query 2: Jobs posted by department "Sales" in January 2011
SELECT job_id
  FROM job_position
 WHERE dep = 'Sales'  -- Using Sales as proxy for Marketing
   AND YEAR(date_posted) = 2011
   AND MONTH(date_posted) = 1;

-- Query 3: Employees with no supervisees
SELECT e.employee_id, CONCAT(p.f_name, ' ', p.l_name) AS employee_name
  FROM employee e
  JOIN person p ON e.employee_id = p.person_id
 WHERE e.employee_id NOT IN (
	SELECT DISTINCT supervisor_id 
	  FROM employee 
	 WHERE supervisor_id IS NOT NULL
);

-- Query 4: Marketing sites with no sales in March 2011
SELECT ms.site_id, ms.site_location
  FROM marketing_sites ms
 WHERE ms.site_id NOT IN (
	SELECT DISTINCT sp.site_id
	  FROM sell_products sp
	 WHERE YEAR(sp.sale_time) = 2011
	   AND MONTH(sp.sale_time) = 3
);

-- Query 5: Jobs with no hire one month after posting
SELECT j.job_id, j.job_disc
  FROM job_position j
 WHERE j.job_id NOT IN (
	SELECT DISTINCT job_id
	  FROM applies_for af
	 WHERE af.employee_id IS NOT NULL
)
   AND j.date_posted <= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- Query 6: Salesmen who sold all product types priced above $200
SELECT mse.employee_id, CONCAT(p.f_name, ' ', p.l_name) AS salesman_name
  FROM marketing_site_employee mse
  JOIN person p ON mse.employee_id = p.person_id
 WHERE NOT EXISTS (
	SELECT DISTINCT pr.product_type
	  FROM product pr
	 WHERE pr.list_price > 200
	   AND pr.product_type NOT IN (
		SELECT DISTINCT p2.product_type
		  FROM sell_products sp
		  JOIN ship_to st ON sp.site_id = st.site_id
		  JOIN product p2 ON st.product_id = p2.product_id
		 WHERE st.site_id = mse.site_id
		   AND p2.list_price > 200
    )
);

-- Query 7: Departments with no job posts between 1/1/2011 and 2/1/2011
SELECT 'HR' AS department, 101 AS dep_id
  FROM dual
 WHERE 'HR' NOT IN (
	SELECT dep
	  FROM job_position
	 WHERE date_posted BETWEEN '2011-01-01' AND '2011-02-01'
)
UNION
SELECT 'Manufacturing' AS department, 201 AS dep_id
  FROM dual
 WHERE 'Manufacturing' NOT IN (
	SELECT dep
	  FROM job_position
	 WHERE date_posted BETWEEN '2011-01-01' AND '2011-02-01'
)
UNION
SELECT 'Sales' AS department, 301 AS dep_id
  FROM dual
 WHERE 'Sales' NOT IN (
	SELECT dep
	  FROM job_position
	 WHERE date_posted BETWEEN '2011-01-01' AND '2011-02-01'
);

-- Query 8: Existing employees who apply for job "12345"
SELECT e.employee_id, CONCAT(p.f_name, ' ', p.l_name) AS employee_name, e.current_dep
  FROM employee e
  JOIN person p ON e.employee_id = p.person_id
 WHERE e.employee_id IN (
	SELECT employee_id
	  FROM applies_for
	 WHERE job_id = 12345
	   AND employee_id IS NOT NULL
);

-- Query 9: Best seller's product type (most items sold)
SELECT product_type
  FROM view3_product_type_sales
 ORDER BY sales_count DESC
 LIMIT 1;

-- Query 10: Product type with highest net profit
SELECT p.product_type, SUM(p.list_price) - AVG(v4.total_part_cost) AS net_profit
  FROM product p
  JOIN view4_product_part_cost v4 ON p.product_id = v4.product_id
 GROUP BY p.product_type
 ORDER BY net_profit DESC
 LIMIT 1;

-- Query 11: Employees who have worked in all departments
SELECT e.employee_id, CONCAT(p.f_name, ' ', p.l_name) AS employee_name
  FROM employee e
  JOIN person p ON e.employee_id = p.person_id
 WHERE e.all_dep LIKE '%HR%' 
   AND e.all_dep LIKE '%Manufacturing%' 
   AND e.all_dep LIKE '%Sales%';

-- Query 12: Name and email of selected interviewee
SELECT p.f_name, p.l_name, pe.person_id, CONCAT(LOWER(p.f_name), '.', LOWER(p.l_name), '@email.com') AS email
  FROM potential_employee pe
  JOIN person p ON pe.person_id = p.person_id
 WHERE pe.app_status = 'Offer Extended'
    OR pe.app_status = 'Hired';

-- Query 13: Interviewees selected for all jobs they applied for
SELECT p.f_name, p.l_name, p.p_num AS phone_number, CONCAT(LOWER(p.f_name), '.', LOWER(p.l_name), '@email.com') AS email
  FROM person p
 WHERE p.person_id IN (
    SELECT pe.person_id
      FROM potential_employee pe
     WHERE NOT EXISTS (
        SELECT 1
          FROM applies_for af
         WHERE af.person_id = pe.person_id
           AND af.job_id NOT IN (
            SELECT i.job_id
              FROM interview i
              JOIN grades g ON i.interview_id = g.interview_id
             WHERE i.person_id = pe.person_id
               AND g.grades >= 85
        )
    )
);

-- Query 14: Employee with highest average monthly salary
SELECT employee_id, employee_name, avg_monthly_salary
  FROM view1_avg_monthly_salary
 ORDER BY avg_monthly_salary DESC
 LIMIT 1;

-- Query 15: Vendor supplying cheapest "Cup" part under 4 pounds
SELECT v.vendor_id, v.vendor_name
  FROM vendors v
  JOIN supplies s ON v.vendor_id = s.vendor_id
  JOIN parts p ON s.part_id = p.part_id
 WHERE p.part_name = 'Cup'
   AND p.weight < 4
 ORDER BY p.part_price ASC
 LIMIT 1;

-- more querries not in the list

-- Get company overview
SELECT 
	(SELECT COUNT(*) FROM employee WHERE emp_status = 'Active') AS active_employees,
	(SELECT COUNT(*) FROM potential_employee WHERE app_status = 'Interview Scheduled') AS pending_interviews,
	(SELECT COUNT(*) FROM product) AS total_products,
	(SELECT COUNT(*) FROM marketing_sites) AS sales_locations,
	(SELECT SUM(amount) FROM salary WHERE MONTH(pay_date) = MONTH(CURDATE())) AS current_month_payroll;

-- Department performance summary
SELECT e.current_dep, COUNT(*) AS employee_count, AVG(s.amount) AS avg_salary, COUNT(DISTINCT j.job_id) AS open_positions
  FROM employee e
  LEFT JOIN salary s ON e.employee_id = s.employee_id
  LEFT JOIN job_position j ON e.current_dep = j.dep AND j.date_posted >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
 WHERE e.emp_status = 'Active'
 GROUP BY e.current_dep;