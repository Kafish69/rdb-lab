SET datestyle TO ISO, DMY;
DROP SCHEMA IF EXISTS enterprise CASCADE; CREATE SCHEMA enterprise; SET search_path TO enterprise;
CREATE TABLE departments (
  department_id   numeric(2)   CONSTRAINT pk_departments PRIMARY KEY,
  department_name varchar(20)  NOT NULL CONSTRAINT uq_dep_name UNIQUE,
  manager_id      varchar(9),
  mgr_start_date  date);
CREATE TABLE employees (
  employee_id   varchar(9)  CONSTRAINT pk_employees PRIMARY KEY,
  last_name     varchar(25) NOT NULL,
  infix         varchar(10),
  first_name    varchar(25),
  street        varchar(40),
  postal_code   varchar(6),
  location      varchar(20),
  province      char(2),
  birth_date    date,
  parking_spot  numeric(4)  CONSTRAINT uq_parking UNIQUE,
  salary        numeric(7),
  gender        char(1),
  department_id numeric(2)  CONSTRAINT fk_emp_dep REFERENCES departments,
  manager_id    varchar(9)  CONSTRAINT fk_emp_mgr REFERENCES employees);
ALTER TABLE departments ADD CONSTRAINT fk_dep_mgr FOREIGN KEY (manager_id) REFERENCES employees DEFERRABLE INITIALLY DEFERRED;
CREATE TABLE locations (
  department_id numeric(2) REFERENCES departments,
  location      varchar(20),
  CONSTRAINT pk_locations PRIMARY KEY (department_id, location));
CREATE TABLE projects (
  project_id    numeric(2)  CONSTRAINT pk_projects PRIMARY KEY,
  project_name  varchar(25) NOT NULL CONSTRAINT uq_proj_name UNIQUE,
  location      varchar(20),
  department_id numeric(2)  REFERENCES departments);
CREATE TABLE tasks (
  employee_id varchar(9) REFERENCES employees,
  project_id  numeric(2) REFERENCES projects,
  hours       numeric(5,1),
  CONSTRAINT pk_tasks PRIMARY KEY (employee_id, project_id));
CREATE TABLE family_members (
  employee_id  varchar(9)  REFERENCES employees,
  name         varchar(25),
  gender       char(1),
  birth_date   date,
  relationship varchar(10),
  CONSTRAINT pk_family PRIMARY KEY (employee_id, name));
BEGIN;
INSERT INTO departments VALUES
 (1,'Headquarters','999666666','19-06-2019'),
 (3,'Administration','999555555','01-01-2021'),
 (7,'Production','999444444','22-05-2018');
INSERT INTO employees VALUES
 ('999666666','Bordoloi',NULL,'Bijoy','Zuidstraat 21','3601AB','Maarssen','UT','10-11-1977',1,55000,'M',1,NULL),
 ('999555555','Joyner',NULL,'Suzan','Kerkstraat 3','6211CD','MAASTRICHT','LI','20-06-1981',3,43000,'F',3,'999666666'),
 ('999444444','Zhu',NULL,'Waiman','Zeeweg 10','5611EF','Eindhoven','NB','08-12-1985',32,43000,'M',7,'999666666'),
 ('999887777','Markis',NULL,'Martina','Lindelaan 7','2341GH','Oegstgeest','ZH','19-07-1988',402,25000,'F',3,'999555555'),
 ('999222222','Jochems',NULL,'Henk','Dorpsstraat 45','9711IJ','Groningen','GR','29-03-1979',422,25000,'M',3,'999555555'),
 ('999111111','Bock',NULL,'Douglas','Zandweg 2','6221KL','Maastricht','LI','01-09-1965',542,30000,'M',7,'999444444'),
 ('999333333','Joosten',NULL,'Willem','Molenweg 8','5612MN','Eindhoven','NB','15-09-1982',332,38000,'M',7,'999444444'),
 ('999888888','Muiden','van der','Sherri','Havenstraat 14','6222OP','Maastricht','LI','31-07-1982',296,25000,'F',7,'999444444');
COMMIT;
INSERT INTO locations VALUES (1,'Maarssen'),(3,'Oegstgeest'),(7,'Eindhoven'),(7,'Maastricht'),(7,'Oegstgeest');
INSERT INTO projects VALUES
 (1,'Ordermanagement','Eindhoven',7),(2,'Salaryadministration','Maastricht',7),(3,'Debtors','Oegstgeest',3),
 (10,'Inventory','Maarssen',3),(20,'Warehouse','Eindhoven',7),(30,'Benefits','Maarssen',1);
INSERT INTO tasks VALUES
 ('999111111',1,31.4),('999111111',2,8.5),('999333333',3,42.1),('999888888',1,21.0),('999888888',2,22.0),
 ('999444444',1,NULL),('999444444',2,12.2),('999444444',3,10.5),('999444444',10,10.1),('999444444',20,11.8),
 ('999887777',10,10.2),('999887777',30,10.8),('999222222',10,34.5),('999222222',30,5.1),
 ('999555555',3,5.0),('999555555',20,20.2),('999555555',30,9.2);
INSERT INTO family_members VALUES
 ('999444444','Jo','F','14-02-2009','DAUGHTER'),('999444444','Andrew','M','25-10-2010','SON'),('999444444','Susan','F','03-05-1985','PARTNER'),
 ('999555555','Allen','M','29-02-1968','PARTNER'),
 ('999111111','Deanna','F','31-12-1988','DAUGHTER'),('999111111','Jeffery','M','01-01-1988','SON'),('999111111','Michael','M','12-04-1998','SON'),('999111111','Mary Ellen','F','05-05-1965','PARTNER'),
 ('999887777','Ruben','M','20-03-1991','PARTNER');

SET search_path TO enterprise;
