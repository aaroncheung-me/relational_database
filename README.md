## Relational Database Design: Manufacturing/Sales Company

A full relational database design and query layer, originally built for a
database systems course at UT Dallas. The assignment: design a schema for a
fictional company that manufactures products, buys parts from vendors, and
manages a workforce across HR, Manufacturing, and Sales.

Most coursework like this never leaves a submission folder. This one's
live.

**See it live:** [aaroncheung.me](https://aaroncheung.me) under "Database
Design". Every query below runs against a real database, including a
working insert/list/delete flow on the customers table.

## What's here

- **`schema.sql`** holds the full schema (CREATE TABLE statements with
  proper primary and foreign keys), seed data, and all 15 of the
  assignment's required queries plus 2 extra (`overview` and department
  performance) used by the live API.
- **`diagrams/`** has the ER diagram, the normalized relational schema, and
  a 2-page entity diagram (made with dbdiagram.io).
- **`php/api.php`** is the API layer the live site calls. One endpoint,
  `?action=<name>`, that runs one of the queries or handles inserting,
  listing, and deleting a customer, and returns JSON.

## Queries

A few of these are legitimately hard. "Employees who have worked in every
department" and "salesmen who sold every product type priced above $200"
are relational division problems - easy to say in English, annoying to
write in SQL. Others just chain a bunch of joins: cheapest vendor for a
part under a weight limit, jobs still unfilled a month after posting.

| Action | Description |
|---|---|
| `overview` | Company-wide summary counts |
| `interviewers` | Interviewers in a specific interview |
| `sales_jobs_jan_2011` | Sales jobs posted in Jan 2011 |
| `employees_no_supervisees` | Employees with no direct reports |
| `sites_no_sales_march_2011` | Marketing sites with no sales in Mar 2011 |
| `unfilled_jobs` | Jobs still open a month after posting |
| `top_salesmen` | Salesmen who sold every product type above $200 |
| `inactive_departments` | Departments with no job posts in a date range |
| `internal_applicants` | Existing employees who applied for a given job |
| `best_selling_type` | Best-selling product type by units sold |
| `highest_profit_type` | Product type with the highest net profit |
| `all_dept_employees` | Employees who've worked in every department |
| `selected_interviewees` | Interviewees who received an offer |
| `selected_for_all` | Interviewees selected for every job they applied to |
| `highest_salary_employee` | Employee with the highest average monthly salary |
| `cheapest_cup_vendor` | Cheapest vendor for a part under a weight limit |
| `insert_customer` / `show_customers` / `delete_customer` | Full write path for the customers table |

## Running it locally

1. Create a MySQL database and import `schema.sql`.
2. Copy `php/config.example.php` to `php/config.php` and fill in your real
   database host, name, username, and password. The file is gitignored on
   purpose. Never commit real credentials.
3. Serve `php/` with any PHP-capable server and hit
   `api.php?action=overview` (or any action from the table).