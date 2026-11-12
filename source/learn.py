# Learn track for complete beginners.
# Each step: t=title, x=explanation (html), ex=example SQL (runs), then either
#   task: (question, solution, hint)   or   mcq: (question, options, answer_index, why)
UNITS = []
def U(title, sub): UNITS.append(dict(title=title, sub=sub, steps=[]))
def step(t, x, ex=None, task=None, mcq=None):
    s = dict(t=t, x=x, ex=ex)
    if task: s['task'] = dict(q=task[0], sol=task[1], hint=task[2] if len(task) > 2 else '')
    if mcq: s['mcq'] = dict(q=mcq[0], o=mcq[1], a=mcq[2], why=mcq[3] if len(mcq) > 3 else '')
    UNITS[-1]['steps'].append(s)

U("What a database is", "Tables, rows, columns and keys. No code yet.")
step("A table is a list with columns",
 "<p>A database stores data in <b>tables</b>. A table looks like a spreadsheet: every <b>row</b> is one thing (one employee) and every <b>column</b> is one property of it (last name, salary).</p><p>Below is part of the <code>employees</code> table. Press Run to see it.</p>",
 "SELECT employee_id, last_name, first_name, salary\nFROM employees;",
 mcq=("In the employees table, what is one row?", ["One employee","One column","All salaries","The whole table"], 0, "Each row describes one employee."))
step("Why not just a spreadsheet?",
 "<p>Imagine typing a customer's address every time they buy something. Soon the same address is in 20 rows (<b>redundancy</b>) and one of them has a typo, so you don't know which is right (<b>inconsistency</b>).</p><p>A database splits data into separate tables so every fact is stored <b>once</b>. The software that manages the database is the <b>DBMS</b>. We use PostgreSQL.</p>",
 mcq=("The same address is stored in many rows. What's that called?", ["Redundancy","A primary key","A query","A DBMS"], 0))
step("Every row needs a unique id: the primary key",
 "<p>Two employees could have the same name. So every table has a <b>primary key (PK)</b>: a column whose value is <b>different for every row</b> and <b>never empty</b>. In <code>employees</code> that's <code>employee_id</code>.</p>",
 "SELECT employee_id, last_name\nFROM employees;",
 mcq=("Which column is the primary key of employees?", ["employee_id","last_name","salary","department_id"], 0, "It's unique and never empty."))
step("Tables are linked with foreign keys",
 "<p>An employee works in a department. Instead of writing the department's name in every employee row, the employee row stores the department's <b>number</b>: <code>employees.department_id</code>. That column points to the primary key of <code>departments</code>. A column that points to another table's PK is a <b>foreign key (FK)</b>.</p>",
 "SELECT department_id, department_name\nFROM departments;",
 mcq=("employees.department_id is 7. What does that tell you?", ["The employee works in the department whose department_id is 7","The employee has 7 departments","The employee's id is 7","Nothing"], 0))

U("Your first queries", "SELECT and FROM: get columns out of one table.")
step("SELECT * shows everything",
 "<p>A question to the database is a <b>query</b>. The simplest one: <code>SELECT *</code> (= all columns) <code>FROM</code> a table. End it with <code>;</code>.</p>",
 "SELECT *\nFROM departments;",
 task=("Show all columns of the table projects.", "SELECT * FROM projects;", "SELECT * FROM table_name;"))
step("Pick only the columns you need",
 "<p>Instead of <code>*</code>, list the columns you want, separated by commas. They appear in the order you write them.</p>",
 "SELECT last_name, salary\nFROM employees;",
 task=("Show the first name and last name of every employee.", "SELECT first_name, last_name FROM employees;", "Two column names with a comma between them."))
step("Rename a column with AS",
 "<p>An <b>alias</b> changes the column header in the result. Want capitals or spaces? Put it in <b>double quotes</b>.</p>",
 "SELECT last_name AS \"Family name\", salary AS yearly\nFROM employees;",
 task=("Show project_name with the header <b>project</b> and location with the header <b>city</b>.", "SELECT project_name AS project, location AS city FROM projects;"))
step("Calculate and glue text",
 "<p>You can calculate in SELECT (<code>+ - * /</code>) and glue text with <code>||</code>. Text you type yourself goes in <b>single quotes</b>.</p>",
 "SELECT last_name, salary / 12 AS per_month,\n       first_name || ' ' || last_name AS full_name\nFROM employees;",
 task=("Show each employee's last name and their salary with a 10% raise (salary * 1.1).", "SELECT last_name, salary * 1.1 FROM employees;"))
step("Remove duplicates with DISTINCT",
 "<p>Several employees work in the same department. <code>DISTINCT</code> shows each value only once.</p>",
 "SELECT DISTINCT department_id\nFROM employees;",
 task=("Show every province where employees live, each only once.", "SELECT DISTINCT province FROM employees;"))

U("Filtering rows", "WHERE: only the rows you want.")
step("WHERE keeps the rows that match",
 "<p>Add <code>WHERE</code> with a condition. Only rows where it's true come back. Numbers are written without quotes.</p>",
 "SELECT last_name, salary\nFROM employees\nWHERE salary > 40000;",
 task=("Show last name and salary of the employees earning less than 30000.", "SELECT last_name, salary FROM employees WHERE salary < 30000;"))
step("Text needs single quotes",
 "<p>To compare with text, put the text in <b>single quotes</b>. Upper and lower case matter: <code>'bock'</code> is not <code>'Bock'</code>.</p>",
 "SELECT employee_id, first_name\nFROM employees\nWHERE last_name = 'Bock';",
 task=("Show all columns of the employee whose first name is Suzan.", "SELECT * FROM employees WHERE first_name = 'Suzan';", "WHERE first_name = '…'"))
step("Ignore upper/lower case with UPPER",
 "<p>Data isn't always typed the same way. One employee lives in <code>'MAASTRICHT'</code>, others in <code>'Maastricht'</code>. Convert the column first, then compare with capitals.</p>",
 "SELECT last_name, location\nFROM employees\nWHERE UPPER(location) = 'MAASTRICHT';",
 task=("Show last name and location of everyone living in Eindhoven, however it's written.", "SELECT last_name, location FROM employees WHERE UPPER(location) = 'EINDHOVEN';"))
step("AND, OR and brackets",
 "<p><code>AND</code>: both must be true. <code>OR</code>: one is enough. AND is done before OR, so use <b>brackets</b> when you mix them.</p>",
 "SELECT last_name, salary, department_id\nFROM employees\nWHERE salary > 30000\n  AND (department_id = 1 OR department_id = 3);",
 task=("Show last name and gender of the female employees (gender 'F') in department 7.", "SELECT last_name, gender FROM employees WHERE gender = 'F' AND department_id = 7;"))
step("BETWEEN and IN",
 "<p><code>BETWEEN 25000 AND 40000</code> includes both limits (small number first). <code>IN (…)</code> is a short way to write many ORs.</p>",
 "SELECT last_name, province\nFROM employees\nWHERE province IN ('LI', 'NB');",
 task=("Show employee_id, project_id and hours of the tasks with between 10 and 20 hours.", "SELECT employee_id, project_id, hours FROM tasks WHERE hours BETWEEN 10 AND 20;"))
step("LIKE: search with a pattern",
 "<p><code>%</code> means \"anything (or nothing)\", <code>_</code> means \"exactly one character\". <code>'B%'</code> = starts with B, <code>'%s'</code> = ends with s.</p>",
 "SELECT last_name\nFROM employees\nWHERE last_name LIKE 'J%';",
 task=("Show the last names that end with 's'.", "SELECT last_name FROM employees WHERE last_name LIKE '%s';"))
step("Empty values: IS NULL",
 "<p>An empty cell is <b>NULL</b>. You can't use <code>= NULL</code> (it never matches). Always write <code>IS NULL</code> or <code>IS NOT NULL</code>.</p>",
 "SELECT employee_id, project_id, hours\nFROM tasks\nWHERE hours IS NULL;",
 task=("Show the last name of every employee who HAS a manager (manager_id not empty).", "SELECT last_name FROM employees WHERE manager_id IS NOT NULL;"))

U("Sorting and limiting", "ORDER BY, OFFSET and FETCH.")
step("ORDER BY sorts the result",
 "<p><code>ASC</code> = small to big (default), <code>DESC</code> = big to small. Sort on several columns with commas: the second one only matters when the first is equal.</p>",
 "SELECT last_name, salary\nFROM employees\nORDER BY salary DESC, last_name;",
 task=("Show last name and birth date of all employees, oldest first.", "SELECT last_name, birth_date FROM employees ORDER BY birth_date;", "Oldest = earliest date = ascending."))
step("Only the top rows: FETCH",
 "<p>After ORDER BY you can cut the list: <code>FETCH FIRST 3 ROWS ONLY</code>. <code>WITH TIES</code> also keeps rows that are equal to the last one. <code>OFFSET 2 ROWS</code> skips rows first.</p>",
 "SELECT last_name, salary\nFROM employees\nORDER BY salary DESC\nFETCH FIRST 2 ROWS WITH TIES;",
 task=("Show the 2 employees with the highest salary (last name and salary). Use ONLY, sorted from high to low.", "SELECT last_name, salary FROM employees ORDER BY salary DESC FETCH FIRST 2 ROWS ONLY;"))
step("The order SQL actually runs in",
 "<p>You write SELECT first, but the database does: <b>FROM → WHERE → SELECT → ORDER BY → FETCH</b>. So an alias from SELECT can be used in ORDER BY, but not in WHERE.</p>",
 mcq=("Which runs first?", ["WHERE","SELECT","ORDER BY","FETCH"], 0, "FROM, then WHERE, then SELECT."))

U("Functions", "Change how values look: text, numbers, dates.")
step("Text functions",
 "<p><code>UPPER</code>, <code>LOWER</code>, <code>LENGTH</code> (number of characters), <code>SUBSTRING(text, start, length)</code> (a piece of the text).</p>",
 "SELECT last_name, UPPER(last_name), LENGTH(last_name),\n       SUBSTRING(last_name, 1, 3) AS first3\nFROM employees;",
 task=("Show every last name in lowercase.", "SELECT LOWER(last_name) FROM employees;"))
step("Rounding numbers",
 "<p><code>ROUND(x, 2)</code> rounds to 2 decimals. <code>TRUNC(x)</code> just cuts the decimals off.</p>",
 "SELECT last_name, salary / 12, ROUND(salary / 12, 2), TRUNC(salary / 12)\nFROM employees;",
 task=("Show last name and the monthly salary (salary / 12) rounded to whole euros.", "SELECT last_name, ROUND(salary / 12) FROM employees;"))
step("Dates: today, age and differences",
 "<p><code>current_date</code> is today. <code>current_date - birth_date</code> gives a number of days. <code>age(birth_date)</code> gives years, months and days. <code>date_part('year', …)</code> takes one part out.</p>",
 "SELECT last_name, birth_date, age(birth_date),\n       date_part('year', age(birth_date)) AS years\nFROM employees;",
 task=("Show the name of each family member and their age in whole years.", "SELECT name, date_part('year', age(birth_date)) FROM family_members;"))
step("Format a date with TO_CHAR",
 "<p><code>TO_CHAR(date, 'mask')</code> turns a date into text: <code>DD</code> day, <code>MM</code> month number, <code>YYYY</code> year, <code>FMMonth</code> month name without extra spaces.</p>",
 "SELECT name, TO_CHAR(birth_date, 'DD/MM/YYYY'), TO_CHAR(birth_date, 'FMMonth YYYY')\nFROM family_members;",
 task=("Show each employee's last name and birth date written like 01-09-1965 (DD-MM-YYYY).", "SELECT last_name, TO_CHAR(birth_date, 'DD-MM-YYYY') FROM employees;"))

U("Joining tables", "Combine rows from two tables.")
step("Why we need a join",
 "<p>employees only has <code>department_id</code>. The <b>name</b> of the department is in <code>departments</code>. A <b>JOIN</b> puts the matching rows side by side, using the FK = PK condition after <code>ON</code>.</p>",
 "SELECT e.last_name, d.department_name\nFROM employees e\nJOIN departments d ON (e.department_id = d.department_id);",
 task=("Show every project's name with the name of the department that supports it.", "SELECT p.project_name, d.department_name FROM projects p JOIN departments d ON (p.department_id = d.department_id);", "projects.department_id = departments.department_id"))
step("Short names for tables",
 "<p><code>employees e</code> gives the table the nickname <code>e</code>. When a column exists in both tables (like department_id) you <b>must</b> say which one: <code>e.department_id</code>.</p>",
 mcq=("Why does SELECT department_id … FROM employees e JOIN departments d … give an error?", ["department_id exists in both tables, so it's ambiguous","department_id doesn't exist","You can't join on numbers","JOIN needs WHERE"], 0))
step("Three tables in a chain",
 "<p><code>tasks</code> connects employees and projects (who works on what, and how many hours). Join them one after the other.</p>",
 "SELECT e.last_name, p.project_name, t.hours\nFROM employees e\nJOIN tasks t ON (e.employee_id = t.employee_id)\nJOIN projects p ON (t.project_id = p.project_id);",
 task=("Show each family member's name with the last name of the employee they belong to.", "SELECT f.name, e.last_name FROM family_members f JOIN employees e ON (f.employee_id = e.employee_id);"))
step("A table joined with itself",
 "<p>An employee's boss is also an employee. Use the same table twice with two nicknames: <code>e</code> for the employee, <code>boss</code> for the manager.</p>",
 "SELECT e.last_name, boss.last_name AS boss\nFROM employees e\nJOIN employees boss ON (e.manager_id = boss.employee_id);",
 task=("Show the last names of the employees whose boss is Zhu.", "SELECT e.last_name FROM employees e JOIN employees boss ON (e.manager_id = boss.employee_id) WHERE boss.last_name = 'Zhu';"))

U("Counting and grouping", "COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING.")
step("One number from many rows",
 "<p><b>Aggregate functions</b> turn a column into one value: <code>COUNT(*)</code> number of rows, <code>SUM</code>, <code>AVG</code>, <code>MIN</code>, <code>MAX</code>. They skip NULLs (except COUNT(*)).</p>",
 "SELECT COUNT(*), SUM(salary), AVG(salary), MIN(salary), MAX(salary)\nFROM employees;",
 task=("How many family members are there in total?", "SELECT COUNT(*) FROM family_members;"))
step("Per group: GROUP BY",
 "<p><code>GROUP BY department_id</code> makes one group per department and calculates per group. <b>Rule:</b> every column in SELECT that isn't inside COUNT/SUM/… must be in GROUP BY.</p>",
 "SELECT department_id, COUNT(*) AS people, ROUND(AVG(salary)) AS avg_salary\nFROM employees\nGROUP BY department_id;",
 task=("Show for each project_id the total number of hours worked (from tasks).", "SELECT project_id, SUM(hours) FROM tasks GROUP BY project_id;"))
step("Filter groups: HAVING",
 "<p><code>WHERE</code> filters rows <b>before</b> grouping. <code>HAVING</code> filters groups <b>after</b> grouping, and can use COUNT/SUM/AVG. You can never put COUNT/SUM in WHERE.</p>",
 "SELECT department_id, COUNT(*)\nFROM employees\nGROUP BY department_id\nHAVING COUNT(*) > 2;",
 task=("Show the project_ids where more than 2 employees work (count the rows in tasks).", "SELECT project_id, COUNT(*) FROM tasks GROUP BY project_id HAVING COUNT(*) > 2;"))

U("Keeping rows without a match", "LEFT JOIN and finding what's missing.")
step("LEFT JOIN keeps everything on the left",
 "<p>A normal JOIN drops employees without family members. <code>LEFT JOIN</code> keeps <b>all</b> rows of the left table and fills the right side with NULL when there's no match.</p>",
 "SELECT e.last_name, f.name\nFROM employees e\nLEFT JOIN family_members f ON (e.employee_id = f.employee_id);",
 task=("Show every department name with its projects, also departments without projects.", "SELECT d.department_name, p.project_name FROM departments d LEFT JOIN projects p ON (d.department_id = p.department_id);"))
step("Who has nothing? LEFT JOIN + IS NULL",
 "<p>After a LEFT JOIN, the rows without a match have NULL on the right side. Keep only those with <code>WHERE right_table.primary_key IS NULL</code>.</p>",
 "SELECT e.last_name\nFROM employees e\nLEFT JOIN family_members f ON (e.employee_id = f.employee_id)\nWHERE f.employee_id IS NULL;",
 task=("Which employees (last name) don't work on any project?", "SELECT e.last_name FROM employees e LEFT JOIN tasks t ON (e.employee_id = t.employee_id) WHERE t.employee_id IS NULL;"))
step("You made it",
 "<p>That's the whole term in small steps. Now go to <b>Exercises</b> for the real exam-style questions, and try a <b>Mock exam</b> when you feel ready. The <b>Notes</b> explain every topic in more depth.</p>",
 mcq=("Employees without family: which column do you test with IS NULL?", ["f.employee_id (part of family_members' primary key)","f.birth_date","e.employee_id","e.last_name"], 0, "Use a column that is never empty in a real row of the right table."))
