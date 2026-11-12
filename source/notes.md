@@ch intro | Databases, keys and data models | Week 1
<p class="lead">Before you write a single query you need the vocabulary: what a database is, why we don't just use a spreadsheet, and how keys tie tables together.</p>

## Why not just a spreadsheet?
<p>A web shop tracks sales in one sheet: name, product, price, quantity, date, address. Anouar buys three times, so his address is typed three times, and once it's different. Two problems appear:</p>
<ul>
<li><b>Redundancy</b>: the same data is stored in several places.</li>
<li><b>Inconsistency</b>: the copies disagree, so you no longer know which one is correct (is that one Anouar who moved, or two different people?).</li>
</ul>
<p>The <b>database approach</b> splits the data into subjects called <b>entities</b> (Customer, Product, Order, Address). Each entity becomes a table and every fact is stored once.</p>

## Benefits of the database approach
<table class="t"><tr><th>Benefit</th><th>What it means</th></tr>
<tr><td>Shared data</td><td>Many users and applications use the same data at the same time.</td></tr>
<tr><td>Integrated and coherent</td><td>All data is stored centrally and related: application → DBMS → DB.</td></tr>
<tr><td>Low redundancy</td><td>Data isn't stored twice (normalisation), so there are few inconsistencies.</td></tr>
<tr><td>Data independence</td><td>The structure is described in the database itself (data dictionary), so a structural change doesn't force a change in the application.</td></tr>
<tr><td>Integrity</td><td>Built-in <b>constraints</b> check business rules automatically (e.g. a maximum rent).</td></tr>
<tr><td>Security</td><td>Centralised, so it's easier to control who may access what and do which operations.</td></tr>
<tr><td>Standards</td><td>Easy to agree on names and formats (an address is always street / number / postal code / city).</td></tr></table>

## Database vs DBMS
<p><b>Database</b>: an integrated collection of data that can be used by many users at the same time and meets the information needs of an organisation. It contains <b>data and metadata</b> (the structure). The documentation of the structure is kept automatically.</p>
<p><b>DBMS</b> (DataBase Management System): the <b>software</b> to use and manage the database. PostgreSQL is a DBMS. It lets you:</p>
<ul><li>retrieve data with queries (SELECT)</li><li>change table contents with DML (INSERT, UPDATE, DELETE)</li><li>define and change the structure with DDL (CREATE, ALTER, DROP)</li><li>handle security, transactions and maintenance (availability, performance, backups)</li></ul>

## Properties of a relational table
<ul>
<li>Every attribute is <b>atomic</b>: one value per cell (a project can't have two department numbers in one cell).</li>
<li>Every row is <b>unique</b>: no duplicate rows.</li>
<li>Rows have <b>no order</b>. Column names are unique and their order has no meaning either.</li>
</ul>

## Terminology
<table class="t"><tr><th>Term</th><th>Meaning</th></tr>
<tr><td>table / relation</td><td>the whole set of rows and columns</td></tr>
<tr><td>column / attribute</td><td>one property, e.g. <code>salary</code></td></tr>
<tr><td>row / tuple</td><td>one record</td></tr>
<tr><td>attribute value</td><td>the value in one cell</td></tr>
<tr><td>population</td><td>the set of values that actually occur in a column</td></tr>
<tr><td>domain</td><td>the set of values that are <i>possible</i> for a column</td></tr>
<tr><td>NULL</td><td>a missing or unknown value. It is not 0 and not an empty string.</td></tr></table>

## The three kinds of key
<div class="key"><p><b>Primary key (PK)</b>: an attribute or combination of attributes that uniquely identifies a row. It must be unique and can never be empty. Prefer a meaningless key (an id): the more meaning a key has, the bigger the chance it has to change.</p>
<p><b>Alternative / candidate key</b>: another attribute that could also have been the PK (email, department_name). It's not used to model relations, but you enforce it with a <b>UNIQUE</b> constraint.</p>
<p><b>Foreign key (FK)</b>: an attribute that refers to the PK (or a unique attribute) of another table. That's how a relationship between two tables is made. Its data type must match the PK it refers to.</p></div>
<p>The FK sits on the <b>many side</b> (*) of a relationship, the PK on the <b>one side</b> (1). Every FK is one line in the data model.</p>

## Integrity rules of the relational model
<table class="t"><tr><th>Rule</th><th>Says</th></tr>
<tr><td>Key constraint</td><td>The PK must be unique and stay unique.</td></tr>
<tr><td>Entity integrity</td><td>The PK must always have a value (never NULL).</td></tr>
<tr><td>Referential integrity</td><td>The values of an FK must be a <b>subset</b> of the values of the PK it refers to (you can't refer to a department that doesn't exist).</td></tr></table>

## Reading a logical data model
<ul>
<li><b>Entity</b>: capital letter, singular (<code>Employee</code>). <b>Attribute</b>: lowercase with underscores (<code>first_name</code>).</li>
<li>Tags: <b>&lt;&lt;PK&gt;&gt;</b> primary key, <b>&lt;&lt;FK&gt;&gt;</b> foreign key, <b>&lt;&lt;NN&gt;&gt;</b> not null (mandatory), <b>&lt;&lt;UQ&gt;&gt;</b> unique.</li>
<li>Multiplicities in this course: <b>1 – *</b> and <b>1 – 1</b>.</li>
<li><b>Many-to-many</b> can't be stored directly. You add an <b>intermediate entity</b> whose PK is the combination of the two FKs. In the shop: <code>Order(customer_id, product_id, …)</code>. In enterprise: <code>tasks(employee_id, project_id, hours)</code>.</li>
<li><b>Recursive relationship</b>: an entity related to itself. <code>employees.manager_id</code> refers to <code>employees.employee_id</code>. The CEO has <code>manager_id</code> = NULL.</li>
</ul>
<div class="trap"><p>"Every customer must have an email and no two customers can share one" → <b>&lt;&lt;NN&gt;&gt; &lt;&lt;UQ&gt;&gt;</b>. Mandatory → NN. Can't repeat → UQ. Both → both tags. It does <b>not</b> become the PK.</p></div>
<p><b>Logical</b> data model: what do we store and how is it related? <b>Physical</b> data model: how do we build it in a specific DBMS (tables, columns, data types such as <code>INT</code>, <code>VARCHAR(100)</code>, <code>DATE</code>, constraints, indexes).</p>

## The enterprise database
<p>All examples and exercises use this database. Click a table name in the playground to see its rows.</p>
<div class="schema" data-db="enterprise"></div>
<ul>
<li><code>employees.department_id</code> → the department the employee <b>works in</b>. <code>departments.manager_id</code> → the employee who <b>manages</b> the department. These are two different relationships.</li>
<li><code>employees.manager_id</code> → the direct boss (recursive).</li>
<li><code>tasks</code> is the intermediate table between employees and projects. <code>hours</code> belongs there because it's about one employee on one project.</li>
<li><code>locations</code> has a composite PK (department_id, location): one department can have several locations.</li>
<li><code>family_members</code> has PK (employee_id, name): two employees can both have a child called Alex.</li>
</ul>

## SQL in one picture
<p>SQL is <b>declarative</b>: you say <i>what</i> you want, not the steps to get it (that would be procedural). You can use it interactively or embedded in a program (Java, C#…).</p>
<table class="t"><tr><th>Group</th><th>Statements</th><th>Purpose</th></tr>
<tr><td>DQL (data retrieval)</td><td>SELECT</td><td>read data</td></tr>
<tr><td>DML</td><td>INSERT, UPDATE, DELETE</td><td>change the contents</td></tr>
<tr><td>DDL</td><td>CREATE, ALTER, DROP, TRUNCATE</td><td>create and change objects</td></tr>
<tr><td>DCL</td><td>GRANT, REVOKE</td><td>security</td></tr>
<tr><td>Transaction control</td><td>COMMIT, ROLLBACK, SAVEPOINT</td><td>group changes that must succeed or fail together</td></tr></table>

## User profiles
<ul><li><b>Data administrator</b>: centrally responsible for the data (what data, which format, which database).</li>
<li><b>Database administrator (DBA)</b>: technically responsible for implementing and maintaining the database.</li>
<li><b>Application developer</b>: builds the applications that use the database.</li>
<li><b>End user</b>: uses the database through an application.</li></ul>

@@ch select | SELECT, WHERE, ORDER BY and FETCH | Week 2
<p class="lead">Everything you'll ever query starts here: one table, the right columns, the right rows, in the right order.</p>

## The skeleton and the order it runs in
```sql
SELECT employee_id, last_name, first_name, department_id
FROM employees
WHERE department_id = 7
ORDER BY employee_id;
```
<div class="key"><p>You <b>write</b> SELECT → FROM → WHERE → ORDER BY, but the database <b>executes</b>:</p>
<ol><li><b>FROM</b>: which table</li><li><b>WHERE</b>: which rows (selection)</li><li><b>SELECT</b>: which columns and how (projection)</li><li><b>ORDER BY</b>: the order</li><li><b>OFFSET / FETCH</b>: how many rows</li></ol>
<p>That's why a column alias made in SELECT can be used in ORDER BY but <b>not</b> in WHERE.</p></div>

## SELECT without FROM
```sql
SELECT 2+2, CURRENT_DATE, 150 * 0.85 AS discounted;
```

## The select list
<ul>
<li><code>*</code> = all columns</li>
<li>constants: <code>'text'</code>, <code>345</code></li>
<li>arithmetic: <code>+ - * /</code></li>
<li><code>||</code> glues text together</li>
<li>functions: <code>SUM()</code>, <code>UPPER()</code>…</li>
</ul>
```sql
SELECT employee_id
      ,last_name || ' ' || first_name AS full_name
      ,salary * 1.1 raise
FROM employees;
```
<p><b>Column alias</b>: with or without <code>AS</code>. Without double quotes, PostgreSQL turns it into lowercase (<code>FamilyName</code> → <code>familyname</code>). With <b>"double quotes"</b> you keep capitals, spaces and any symbol.</p>
```sql
SELECT employee_id "Employee {number}", last_name AS "Family name"
FROM employees;
```
<div class="key"><p><b>Quote rules</b>: numbers no quotes · text and dates in <b>'single quotes'</b> · identifiers (aliases with spaces/capitals) in <b>"double quotes"</b>.</p></div>

## DISTINCT
<p>Removes duplicate <b>rows</b> from the result. With several columns, the <i>combination</i> must be unique.</p>
```sql
SELECT DISTINCT department_id FROM employees;
```
```sql
SELECT DISTINCT department_id dept, salary FROM employees;
```

## WHERE: picking rows
<p>Comparisons: <code>= &lt;&gt; != &lt; &gt; &lt;= &gt;=</code>.</p>
```sql
SELECT employee_id, last_name, birth_date
FROM employees
WHERE birth_date < '31-12-1980';
```
<p><b>BETWEEN low AND high</b>: both limits included, and low must come first. <code>BETWEEN 40000 AND 25000</code> returns nothing.</p>
```sql
SELECT employee_id, last_name, salary
FROM employees
WHERE salary BETWEEN 25000 AND 40000;
```
<p><b>Text is case-sensitive.</b> <code>first_name = 'WILLEM'</code> finds nothing. Convert first:</p>
```sql
SELECT employee_id FROM employees WHERE UPPER(first_name) = 'WILLEM';
```
<p><code>INITCAP('hELLO wORLD')</code> → <code>Hello World</code>.</p>

## LIKE with wildcards
<table class="t"><tr><th>Wildcard</th><th>Means</th></tr><tr><td><code>%</code></td><td>0, 1 or many characters</td></tr><tr><td><code>_</code></td><td>exactly one character</td></tr></table>
```sql
SELECT employee_id, last_name FROM employees
WHERE UPPER(last_name) LIKE '_O%';   -- 2nd letter is an O
```
<p><code>'%ases_'</code> matches <i>databases1</i>, not <i>databases</i> (the _ needs one character) and not <i>cases77</i> (only one).</p>

## AND, OR, NOT and brackets
<div class="trap"><p><b>AND is evaluated before OR.</b> This query means "(salary &gt; 30000 AND dept 1) OR dept 3", so every dept-3 employee appears, whatever the salary:</p></div>
```sql
SELECT employee_id, salary, department_id FROM employees
WHERE salary > 30000 AND department_id = 1 OR department_id = 3;
```
```sql
SELECT employee_id, salary, department_id FROM employees
WHERE salary > 30000 AND (department_id = 1 OR department_id = 3);
```

## IN (list)
```sql
SELECT employee_id, first_name, salary FROM employees
WHERE first_name IN ('Suzan', 'Martina');
```
<p><code>NOT IN</code> is the opposite. <code>IN</code> is the short way of writing many ORs.</p>

## IS NULL / IS NOT NULL
<div class="trap"><p><code>= NULL</code>, <code>!= NULL</code> and <code>NOT x = NULL</code> never return anything. NULL isn't a value you can compare: comparing with NULL gives "unknown". Always use <b>IS NULL</b> / <b>IS NOT NULL</b>.</p></div>
```sql
SELECT employee_id, last_name FROM employees WHERE manager_id IS NULL;
```
```sql
SELECT * FROM tasks WHERE hours = NULL;   -- runs, but returns 0 rows!
```

## ORDER BY
<ul>
<li><code>ASC</code> is the default, <code>DESC</code> reverses.</li>
<li>Several columns: sort by the first, then <i>within</i> equal values by the second.</li>
<li>You can sort by alias or by column <b>number</b> in the select list.</li>
<li><b>NULL counts as the largest value</b>: last with ASC, first with DESC. Change with <code>NULLS FIRST</code> / <code>NULLS LAST</code>.</li>
</ul>
```sql
SELECT employee_id, last_name "long name", department_id dept
FROM employees
ORDER BY dept DESC, "long name" ASC;
```
```sql
SELECT * FROM tasks ORDER BY hours ASC NULLS FIRST;
```

## Pagination: OFFSET and FETCH
```sql
SELECT last_name FROM employees
ORDER BY last_name
OFFSET 3 ROWS
FETCH NEXT 4 ROWS ONLY;
```
<ul>
<li><code>OFFSET n ROWS</code> skips n rows (default 0). OFFSET bigger than the number of rows → no output. An expression must be in brackets: <code>OFFSET (2*2) ROWS</code>.</li>
<li><code>FETCH NEXT n ROWS ONLY</code> returns at most n rows. <code>FIRST</code> = <code>NEXT</code>, <code>ROW</code> = <code>ROWS</code>.</li>
<li>Always combine with <b>ORDER BY</b>, otherwise "the first 3" means nothing (rows have no order).</li>
</ul>
<div class="key"><p><b>WITH TIES</b>: also returns the rows that are equal to the last one. "Top 2 salaries" with ONLY cuts one of the two 43000 earners off. WITH TIES shows both, so you get 3 rows.</p></div>
```sql
SELECT last_name, salary FROM employees
ORDER BY salary DESC
FETCH FIRST 2 ROWS WITH TIES;
```
<p>PostgreSQL also knows <code>LIMIT 3 OFFSET 2</code>, but the course uses OFFSET/FETCH.</p>

@@ch functions | Conversions, numbers, dates and text | Week 3
<p class="lead">Functions change how values look or let you calculate with them. The exam loves TO_CHAR masks, date arithmetic and text functions like SUBSTRING and POSITION.</p>

## Implicit vs explicit conversion
<p>PostgreSQL converts automatically where it can: <code>'29-10-2010'</code> becomes a date when a date is expected, and a date becomes text in <code>'*** ' || current_date</code>. This depends on client settings (<code>datestyle</code>), so it's safer to convert <b>explicitly</b>.</p>
```sql
SHOW datestyle;
```
<p>This site uses <code>ISO, DMY</code>: dates are shown as 2026-11-12 and typed as day-month-year ('31-12-1980', '1-JAN-1980').</p>

## TO_CHAR: date or number → text
```sql
SELECT name, to_char(birth_date, 'DD/MM/YYYY') AS dmy
      ,to_char(birth_date, 'FMDay DD FMMonth YYYY') AS long
FROM family_members;
```
<table class="t"><tr><th>Mask</th><th>Gives</th><th>Mask</th><th>Gives</th></tr>
<tr><td>YYYY / YY</td><td>2026 / 26</td><td>Month / month / MONTH</td><td>November (padded to 9 chars)</td></tr>
<tr><td>MM</td><td>11</td><td>Mon</td><td>Nov</td></tr>
<tr><td>DD</td><td>day of month 12</td><td>Day / Dy</td><td>Thursday / Thu</td></tr>
<tr><td>D</td><td>day of week (1 = Sunday)</td><td>DDD</td><td>day of year</td></tr>
<tr><td>HH24:MI:SS</td><td>17:05:09</td><td>Q / WW</td><td>quarter / week of year</td></tr></table>
<div class="key"><p><b>FM</b> (fill mode) removes the padding spaces: <code>'Month'</code> → "May&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", <code>'FMMonth'</code> → "May". <b>TM</b> (translation mode) uses the language of <code>lc_time</code> for day and month names.</p></div>
<p>Numbers: <code>9</code> = digit (dropped if not significant), <code>0</code> = digit always shown, <code>.</code> or <code>D</code> = decimal point, <code>,</code> or <code>G</code> = group separator, <code>L</code> = currency, <code>S</code> = sign. A leading space is reserved for the sign, so <code>trim()</code> it or use FM.</p>
```sql
SELECT '*'||to_char(485,'999')||'*', '*'||to_char(485,'0999.9')||'*', '*'||to_char(485,'FM999')||'*';
```
<div class="trap"><p><code>employee_id</code> is <b>text</b> (varchar). <code>WHERE employee_id = 999666666</code> fails (text = integer). Fix: quotes <code>'999666666'</code>, or <code>CAST(employee_id AS INT) = 999666666</code>, or <code>trim(to_char(999666666,'999999999'))</code>.</p></div>

## TO_DATE, TO_NUMBER, CAST
```sql
SELECT to_date('20 Sep 2021','DD Mon YYYY')
      ,to_number('12,345.6-','99,999.9S')
      ,CAST('2500' AS INT) + 3
      ,'2500'::int + 3;
```
<p><code>to_date('20 Sep','DD Mon')</code> without a year gives year 1 BC. <code>x::type</code> is PostgreSQL's short form of CAST.</p>

## ROUND, TRUNC, MOD
```sql
SELECT round(15251.675), round(15251.675,1), round(15256.675,-1)
      ,trunc(15251.675,1), trunc(15251.675,-1), mod(5,3), mod(7,35);
```
<p><b>ROUND</b> rounds, <b>TRUNC</b> just cuts off. A negative position works left of the decimal point (-1 = tens). <b>MOD</b> is the remainder after division.</p>

## Dates and times
<ul>
<li><code>current_date</code>, <code>current_time</code>, <code>current_timestamp</code> / <code>now()</code></li>
<li><b>date − date = number of days</b> (an integer)</li>
<li>date + 7 = seven days later. Use <code>interval</code> for anything else: <code>+ interval '3 months'</code></li>
<li><code>age(birth_date)</code> → an interval like "45 years 4 mons 22 days"</li>
<li><code>date_part('year', …)</code> = <code>EXTRACT(YEAR FROM …)</code></li>
<li><code>date_part('dow', …)</code>: Sunday 0 … Saturday 6. <code>'isodow'</code>: Monday 1 … Sunday 7</li>
<li><code>date_trunc('month', ts)</code> cuts a timestamp back to the start of the month</li>
</ul>
```sql
SELECT last_name, birth_date
      ,date_part('year', age(birth_date)) AS age
      ,birth_date + interval '65 years' AS retirement
FROM employees;
```
```sql
SELECT employee_id, name FROM family_members
WHERE relationship IN ('SON','DAUGHTER')
  AND date_part('year', age(birth_date)) < 18;
```

## Text functions
<table class="t"><tr><th>Function</th><th>Example → result</th></tr>
<tr><td>UPPER / LOWER / INITCAP</td><td>INITCAP('jan peeters') → Jan Peeters</td></tr>
<tr><td>LENGTH(s)</td><td>LENGTH('Jan Janssens') → 12 (spaces count)</td></tr>
<tr><td>SUBSTRING(s, start, len) / SUBSTR</td><td>SUBSTRING('Bordoloi',1,4) → Bord. Without len: to the end.</td></tr>
<tr><td>POSITION('o' IN s)</td><td>POSITION('o' IN 'Bordoloi') → 2 (first one, 0 if absent)</td></tr>
<tr><td>CONCAT(a, b, …)</td><td>ignores NULL</td></tr>
<tr><td>CONCAT_WS(sep, a, b, …)</td><td>CONCAT_WS(',', 'a', 2, NULL, 22) → a,2,22</td></tr>
<tr><td>LPAD / RPAD(s, n, fill)</td><td>LPAD('hi',5,'xy') → xyxhi. A longer string is <b>cut</b> to n.</td></tr>
<tr><td>TRIM([LEADING|TRAILING|BOTH] 'c' FROM s)</td><td>default BOTH and a space</td></tr>
<tr><td>REPLACE(s, from, to)</td><td>REPLACE('ab*cd*','*','') → abcd</td></tr></table>
<div class="trap"><p><code>'a' || NULL</code> is <b>NULL</b>, while <code>CONCAT('a', NULL)</code> is <b>'a'</b>. Watch out with <code>infix</code>, which is often NULL.</p></div>
```sql
SELECT first_name || ' ' || infix || ' ' || last_name AS with_bars
      ,CONCAT_WS(' ', first_name, infix, last_name) AS with_concat_ws
FROM employees;
```
```sql
SELECT lower(substring(first_name,1,3)) || '.' || lower(substring(last_name,1,3)) || '@kdg.be' AS email
FROM employees;
```
<p>TRIM removes <i>characters from a set</i>, not a word: <code>TRIM('DRN' FROM 'PARTNER')</code> → "PARTNE" (only the R at the end is in the set and it stops at E).</p>

@@ch joins | Inner, non-equi and self joins | Week 4
<p class="lead">Data is split over tables, so most real questions need a join: put rows of two tables side by side when a condition matches.</p>

## The Cartesian product (what goes wrong)
```sql
SELECT employee_id, last_name, department_name
FROM employees, departments;
```
<p>No join condition → every employee combined with every department: 8 × 3 = 24 rows, most of them nonsense.</p>

## INNER JOIN … ON
```sql
SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e
JOIN departments d ON (e.department_id = d.department_id);
```
<ul>
<li><code>INNER</code> is the default, so <code>JOIN</code> = <code>INNER JOIN</code>.</li>
<li>Only rows with a match on both sides appear.</li>
<li>A column that exists in both tables (<code>department_id</code>) must be <b>prefixed</b> or you get "column reference is ambiguous".</li>
<li><b>Table aliases</b> (<code>e</code>, <code>d</code>) keep it short. Once you give an alias, use it.</li>
<li>You can still add <code>WHERE</code> and <code>ORDER BY</code>.</li>
</ul>

## USING and NATURAL JOIN
```sql
SELECT employee_id, last_name, department_id, department_name
FROM employees JOIN departments USING (department_id);
```
<p><code>USING (col)</code> works when the column has the same name in both tables. Then you write it <b>without</b> prefix.</p>
<div class="trap"><p><b>NATURAL JOIN</b> joins on <i>every</i> column with the same name. employees and departments both have <code>manager_id</code>, so it joins on department_id <b>and</b> manager_id and gives a wrong (much smaller) result. Prefer USING or ON.</p></div>
```sql
SELECT employee_id, last_name, department_name
FROM employees NATURAL JOIN departments;
```

## Three or more tables
```sql
SELECT e.last_name, p.project_name, t.hours
FROM employees e
JOIN tasks t    ON (e.employee_id = t.employee_id)
JOIN projects p ON (t.project_id = p.project_id);
```
<p>Join in a chain: each ON may only use tables that are already in the FROM above it. tasks is the bridge between employees and projects.</p>
<p>With a <b>composite key</b> you join on all its parts: <code>ON (e.student_id = g.student_id AND e.section_id = g.section_id)</code>.</p>

## Non-equi join
<p>The condition doesn't have to be <code>=</code>. Classic: find the salary scale where the salary falls between a lower and upper limit.</p>
```sql
SELECT e.last_name, e.salary, p.project_name, p.location
FROM employees e
JOIN projects p ON (p.location <> e.location AND p.department_id = e.department_id);
```
<p>Pattern: <code>JOIN scales ON (salary/12 BETWEEN limit_lower AND limit_upper)</code>.</p>

## Self join
<p>A table joined with itself, with two different aliases as if they were two tables.</p>
<p><b>Who is the boss of 999444444?</b> <code>e</code> = the employee, <code>mgr</code> = the boss.</p>
```sql
SELECT mgr.last_name
FROM employees e
JOIN employees mgr ON (e.manager_id = mgr.employee_id)
WHERE e.employee_id = '999444444';
```
<p><b>Every employee with the name of their boss:</b></p>
```sql
SELECT e.last_name, e.first_name, boss.last_name AS boss
FROM employees e
JOIN employees boss ON (e.manager_id = boss.employee_id);
```
<p>Bordoloi is missing: he has no boss (manager_id NULL), so an inner join drops him. (Week 5: LEFT JOIN keeps him.)</p>
<p><b>Who ELSE works in the same department as Bock?</b></p>
```sql
SELECT e.last_name, e.department_id
FROM employees bock
JOIN employees e ON (bock.department_id = e.department_id)
WHERE UPPER(bock.last_name) = 'BOCK'
  AND UPPER(e.last_name) <> 'BOCK';
```
<p><b>Who earns more than Bock?</b> (a self non-equi join; Bock drops out automatically because he doesn't earn more than himself)</p>
```sql
SELECT e.last_name, e.salary
FROM employees e
JOIN employees bock ON (bock.salary < e.salary)
WHERE UPPER(bock.last_name) = 'BOCK';
```
<p><b>Pairs living in the same place, without doubles:</b> use <code>&lt;</code> instead of <code>&lt;&gt;</code>, otherwise you get (A,B) and (B,A).</p>
```sql
SELECT e1.location, e1.first_name, e2.first_name
FROM employees e1
JOIN employees e2 ON (UPPER(e1.location) = UPPER(e2.location) AND e1.employee_id < e2.employee_id)
ORDER BY e1.location;
```
<p><b>Recursive: whose boss's boss is Bordoloi?</b> Join three times.</p>
```sql
SELECT e.last_name
FROM employees e
JOIN employees boss  ON (e.manager_id = boss.employee_id)
JOIN employees boss2 ON (boss.manager_id = boss2.employee_id)
WHERE boss2.last_name = 'Bordoloi';
```
<div class="key"><p>Method for every self join: first write it in steps ("step 1: what are Bock's hours on project 2? step 2: who has more?"), then merge the steps into one query with one alias per role.</p></div>

@@ch group | Aggregate functions, GROUP BY and HAVING | Week 5
<p class="lead">Aggregate functions turn many rows into one number. GROUP BY does that per group; HAVING filters the groups.</p>

## The five functions
```sql
SELECT COUNT(*) AS n, SUM(salary), ROUND(AVG(salary)), MIN(salary), MAX(salary)
FROM employees;
```
<ul>
<li>They <b>ignore NULL</b>, except <code>COUNT(*)</code> which counts rows.</li>
<li><code>COUNT(*)</code> = number of rows · <code>COUNT(col)</code> = number of non-NULL values · <code>COUNT(DISTINCT col)</code> = number of different non-NULL values.</li>
<li><code>SUM(DISTINCT salary)</code> adds every different salary only once.</li>
<li>MIN/MAX also work on text (alphabetical) and dates (MIN birth_date = the oldest person).</li>
</ul>
```sql
SELECT COUNT(*), COUNT(hours), COUNT(DISTINCT employee_id) FROM tasks;
```
<div class="trap"><p>An aggregate function is <b>never allowed in WHERE</b>. <code>WHERE AVG(salary) &gt; 30000</code> → error. WHERE runs per row, before any group exists.</p></div>

## GROUP BY
```sql
SELECT department_id, COUNT(*) AS count_emp, ROUND(AVG(salary)) AS avg_sal
FROM employees
GROUP BY department_id
ORDER BY department_id;
```
<div class="key"><p><b>The golden rule</b>: every column in SELECT that is not inside an aggregate function must be in GROUP BY. <code>SELECT department_id, COUNT(*), first_name … GROUP BY department_id</code> → error: which of the four first names should it show?</p></div>
<p>Grouping on several columns makes a group per combination:</p>
```sql
SELECT department_id, gender, COUNT(*)
FROM employees
GROUP BY department_id, gender
ORDER BY 1, 2;
```

## HAVING
```sql
SELECT department_id, ROUND(AVG(salary)) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 33000;
```
<table class="t"><tr><th></th><th>WHERE</th><th>HAVING</th></tr>
<tr><td>filters</td><td>individual rows</td><td>whole groups</td></tr>
<tr><td>runs</td><td>before grouping</td><td>after grouping</td></tr>
<tr><td>aggregates allowed?</td><td>no</td><td>yes</td></tr></table>
<div class="key"><p>Full execution order: <b>FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → OFFSET/FETCH</b>. So an alias from SELECT can't be used in HAVING (<code>HAVING avg_salary &gt; 33000</code> fails), but it can in ORDER BY.</p></div>
<p>A filter on a normal column belongs in WHERE (faster, it throws rows away before grouping): <code>WHERE UPPER(location) IN ('EINDHOVEN','OEGSTGEEST')</code> beats putting it in HAVING.</p>
```sql
SELECT department_id, AVG(salary)
FROM employees
WHERE gender = 'F'
GROUP BY department_id
HAVING AVG(salary) > 30000;
```

## Nesting aggregates
<p><code>AVG(MAX(salary))</code> needs a GROUP BY and then can only return one row (no department_id next to it). Cleaner: put the inner step in a subquery in FROM.</p>
```sql
SELECT ROUND(AVG(max_sal)) AS avg_of_max
FROM (SELECT MAX(salary) AS max_sal FROM employees GROUP BY department_id) AS x;
```

## Aggregates with joins
```sql
SELECT p.project_name, COUNT(t.employee_id) AS workers, SUM(t.hours) AS total
FROM projects p
JOIN tasks t ON (p.project_id = t.project_id)
GROUP BY p.project_name
HAVING SUM(t.hours) > 30
ORDER BY p.project_name;
```

@@ch outer | Outer joins | Week 5
<p class="lead">An inner join only keeps matches. An outer join keeps all rows of one (or both) tables and fills the missing side with NULL.</p>

## The idea: a temporary NULL row
<p>For every row without a match, the outer join temporarily adds a <b>NULL row</b> to the other table. You choose which table must keep all its rows.</p>
```sql
SELECT e.employee_id, e.first_name, f.name, f.relationship
FROM employees e
LEFT JOIN family_members f ON (e.employee_id = f.employee_id)
ORDER BY e.employee_id;
```
<table class="t"><tr><th>Join</th><th>Keeps</th></tr>
<tr><td>[INNER] JOIN</td><td>only matches</td></tr>
<tr><td>LEFT [OUTER] JOIN</td><td>all rows of the table on the left (before JOIN)</td></tr>
<tr><td>RIGHT [OUTER] JOIN</td><td>all rows of the table on the right</td></tr>
<tr><td>FULL [OUTER] JOIN</td><td>all rows of both</td></tr></table>
<p><code>A LEFT JOIN B</code> = <code>B RIGHT JOIN A</code>.</p>

## Who has NO match? (anti-join)
```sql
SELECT e.employee_id, e.last_name
FROM employees e
LEFT JOIN family_members f ON (e.employee_id = f.employee_id)
WHERE f.employee_id IS NULL;
```
<div class="trap"><p>Test IS NULL on a column that can <b>never</b> be NULL in a real row: the PK or a NOT NULL column of the right table (<code>f.employee_id</code>, <code>f.name</code>). If you test a nullable column (<code>f.birth_date</code>, <code>t.hours</code>), real rows with an empty value also slip in. In the slides, Bock and his daughter Anke (without birth_date) appear by mistake.</p></div>
<p>Also look at <i>which</i> column you show: <code>f.employee_id</code> is NULL for the unmatched rows, <code>e.employee_id</code> never is.</p>

## Projects nobody works on, employees with no tasks
```sql
SELECT e.first_name, e.last_name
FROM employees e
LEFT JOIN tasks t ON (e.employee_id = t.employee_id)
WHERE t.project_id IS NULL;
```

## Counting after an outer join
<div class="key"><p><code>COUNT(*)</code> also counts the NULL row, so an employee with 0 projects gets <b>1</b>. Use <code>COUNT(t.project_id)</code> to get 0.</p></div>
```sql
SELECT e.last_name, COUNT(*) AS wrong, COUNT(t.project_id) AS right_count
FROM employees e
LEFT JOIN tasks t ON (e.employee_id = t.employee_id)
GROUP BY e.employee_id, e.last_name
ORDER BY right_count;
```

## Self outer join: employees who manage nobody
```sql
SELECT e.last_name
FROM employees e
LEFT JOIN employees sub ON (sub.manager_id = e.employee_id)
WHERE sub.employee_id IS NULL;
```
<p>And every employee with their boss, the CEO included:</p>
```sql
SELECT e.last_name, boss.last_name AS boss
FROM employees e
LEFT JOIN employees boss ON (e.manager_id = boss.employee_id);
```

## FULL OUTER JOIN
<p>Shows departments without employees <b>and</b> employees without department in one result. Try it after adding both in the playground:</p>
```sql
INSERT INTO departments VALUES (4, 'Research', '999444444', now());
INSERT INTO employees (employee_id, last_name, first_name) VALUES ('999999999','Janssens','Jan');
SELECT d.department_id, d.department_name, e.employee_id, e.last_name
FROM departments d
FULL JOIN employees e ON (d.department_id = e.department_id)
ORDER BY d.department_id;
```
<p class="small">Changes made by a Run button here are rolled back right away, so the database stays clean.</p>

@@ch exam | Exam guide | Recap
<p class="lead">On the exam you get a database and <b>open questions</b>: you write the SQL yourself, without IDE. Practise on paper first, then check it here.</p>

## How to attack every question
<ol>
<li><b>Which tables?</b> Underline every attribute the question mentions and find its table. Need two tables? Find the FK that links them.</li>
<li><b>Which rows?</b> → WHERE. "per …" or "for each …" → GROUP BY. A condition on a count/sum/average → HAVING.</li>
<li><b>"also those without …" / "all … (if any)"</b> → OUTER JOIN. "who doesn't have …" → LEFT JOIN + IS NULL on a PK column.</li>
<li><b>Compare with another row of the same table</b> ("same department as", "earns more than") → self join.</li>
<li><b>Which columns and headers?</b> Match the result table exactly: aliases, concatenation, order of columns.</li>
<li><b>ORDER BY</b> last. Check NULLs, case (UPPER) and quotes.</li>
</ol>

## The mistakes that cost points
<ul>
<li><code>= NULL</code> instead of <code>IS NULL</code>.</li>
<li>Aggregate in WHERE; non-aggregated column missing from GROUP BY.</li>
<li>Alias used in WHERE or HAVING.</li>
<li>Missing brackets around OR.</li>
<li>Text compared without UPPER/LOWER, so 'MAASTRICHT' and 'Maastricht' differ.</li>
<li>Number written with quotes or text id without quotes.</li>
<li>Ambiguous column: prefix it.</li>
<li>COUNT(*) after a LEFT JOIN.</li>
<li>FETCH without ORDER BY; ONLY where WITH TIES was asked ("the employee(s) with the lowest salary").</li>
<li><code>||</code> with a NULL column wipes the whole text.</li>
<li>BETWEEN with the high value first.</li>
</ul>
