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

DROP SCHEMA IF EXISTS netflix CASCADE; CREATE SCHEMA netflix; SET search_path TO netflix;
CREATE TABLE movie (id int PRIMARY KEY, title varchar(80) NOT NULL, original_title varchar(80), release_date date, runtime int, available_globally boolean NOT NULL, locale varchar(10), created_date timestamp NOT NULL, modified_date timestamp);
CREATE TABLE tv_show (id int PRIMARY KEY, title varchar(80) NOT NULL, original_title varchar(80), release_date date, available_globally boolean NOT NULL, locale varchar(10), created_date timestamp NOT NULL, modified_date timestamp);
CREATE TABLE season (id int PRIMARY KEY, title varchar(80) NOT NULL, season_number int, runtime int, release_date date, tv_show_id int REFERENCES tv_show, created_date timestamp NOT NULL, modified_date timestamp);
CREATE TABLE view_summary (id int PRIMARY KEY, start_date date NOT NULL, end_date date NOT NULL, duration varchar(15) NOT NULL, hours_viewed int, views int, view_rank int, cumulative_weeks_in_top10 int, movie_id int REFERENCES movie, season_id int REFERENCES season, created_date timestamp NOT NULL, modified_date timestamp);
INSERT INTO movie VALUES
 (1,'Red Notice','Red Notice','12-11-2021',118,true,'en','01-12-2023 10:00',NULL),
 (2,'Glass Onion','Glass Onion: A Knives Out Mystery','23-12-2022',139,true,'en','01-12-2023 10:00',NULL),
 (3,'Extraction 2','Extraction 2','16-06-2023',122,true,'en','01-12-2023 10:00','02-01-2024 09:30'),
 (4,'The Gray Man','The Gray Man','22-07-2022',129,true,'en','01-12-2023 10:00',NULL),
 (5,'Leave the World Behind','Leave the World Behind','08-12-2023',141,true,'en','01-12-2023 10:00',NULL),
 (6,'Society of the Snow','La sociedad de la nieve','04-01-2024',144,true,'es','05-01-2024 08:00',NULL),
 (7,'Lift','Lift','12-01-2024',107,true,'en','13-01-2024 08:00',NULL),
 (8,'Damsel','Damsel','08-03-2024',110,true,'en','09-03-2024 08:00',NULL),
 (9,'Bird Box','Bird Box','21-12-2018',124,false,'en','01-12-2023 10:00',NULL),
 (10,'All Quiet on the Western Front','Im Westen nichts Neues','28-10-2022',148,true,'de','01-12-2023 10:00',NULL),
 (11,'The Old Guard 2','The Old Guard 2',NULL,NULL,false,'en','20-02-2024 12:00',NULL),
 (12,'Kill Boksoon','길복순','31-03-2023',137,true,'ko','01-12-2023 10:00',NULL);
INSERT INTO tv_show VALUES
 (1,'Squid Game','오징어 게임','17-09-2021',true,'ko','01-12-2023 10:00',NULL),
 (2,'Wednesday','Wednesday','23-11-2022',true,'en','01-12-2023 10:00',NULL),
 (3,'Stranger Things','Stranger Things','15-07-2016',true,'en','01-12-2023 10:00',NULL),
 (4,'Bridgerton','Bridgerton','25-12-2020',true,'en','01-12-2023 10:00',NULL),
 (5,'Money Heist','La casa de papel','02-05-2017',true,'es','01-12-2023 10:00',NULL),
 (6,'Dark','Dark','01-12-2017',false,'de','01-12-2023 10:00',NULL),
 (7,'One Piece','One Piece','31-08-2023',true,'en','01-12-2023 10:00',NULL);
INSERT INTO season VALUES
 (1,'Squid Game: Season 1',1,485,'17-09-2021',1,'01-12-2023 10:00',NULL),
 (2,'Squid Game: Season 2',2,431,'26-12-2024',1,'27-12-2024 10:00',NULL),
 (3,'Wednesday: Season 1',1,390,'23-11-2022',2,'01-12-2023 10:00',NULL),
 (4,'Stranger Things 3',3,470,'04-07-2019',3,'01-12-2023 10:00',NULL),
 (5,'Stranger Things 4',4,770,'27-05-2022',3,'01-12-2023 10:00',NULL),
 (6,'Bridgerton: Season 2',2,480,'25-03-2022',4,'01-12-2023 10:00',NULL),
 (7,'Bridgerton: Season 3',3,520,'16-05-2024',4,'17-05-2024 10:00',NULL),
 (8,'Money Heist: Part 5',5,560,'03-09-2021',5,'01-12-2023 10:00',NULL),
 (9,'Dark: Season 3',3,NULL,'27-06-2020',6,'01-12-2023 10:00',NULL),
 (10,'One Piece: Season 1',1,470,'31-08-2023',7,'01-12-2023 10:00',NULL),
 (11,'Stranger Things 5',5,NULL,NULL,3,'20-02-2024 12:00',NULL);
INSERT INTO view_summary VALUES
 (1,'01-07-2023','31-12-2023','SEMI_ANNUALLY',150900000,72400000,NULL,NULL,1,NULL,'02-01-2024 08:00',NULL),
 (2,'01-07-2023','31-12-2023','SEMI_ANNUALLY',201500000,86900000,NULL,NULL,3,NULL,'02-01-2024 08:00',NULL),
 (3,'01-07-2023','31-12-2023','SEMI_ANNUALLY',121000000,51500000,NULL,NULL,5,NULL,'02-01-2024 08:00',NULL),
 (4,'01-07-2023','31-12-2023','SEMI_ANNUALLY',507700000,61900000,NULL,NULL,NULL,3,'02-01-2024 08:00',NULL),
 (5,'01-07-2023','31-12-2023','SEMI_ANNUALLY',840300000,99500000,NULL,NULL,NULL,10,'02-01-2024 08:00',NULL),
 (6,'01-07-2023','31-12-2023','SEMI_ANNUALLY',187100000,23200000,NULL,NULL,NULL,1,'02-01-2024 08:00',NULL),
 (7,'01-07-2023','31-12-2023','SEMI_ANNUALLY',96600000,12500000,NULL,NULL,NULL,5,'02-01-2024 08:00',NULL),
 (8,'01-01-2024','30-06-2024','SEMI_ANNUALLY',164200000,98200000,NULL,NULL,7,NULL,'02-07-2024 08:00',NULL),
 (9,'01-01-2024','30-06-2024','SEMI_ANNUALLY',192600000,98200000,NULL,NULL,6,NULL,'02-07-2024 08:00',NULL),
 (10,'01-01-2024','30-06-2024','SEMI_ANNUALLY',138400000,75500000,NULL,NULL,8,NULL,'02-07-2024 08:00',NULL),
 (11,'01-01-2024','30-06-2024','SEMI_ANNUALLY',395600000,45000000,NULL,NULL,NULL,7,'02-07-2024 08:00',NULL),
 (12,'01-01-2024','30-06-2024','SEMI_ANNUALLY',283500000,22200000,NULL,NULL,NULL,9,'02-07-2024 08:00',NULL),
 (13,'01-01-2024','07-01-2024','WEEKLY',30200000,12600000,1,1,6,NULL,'08-01-2024 08:00',NULL),
 (14,'01-01-2024','07-01-2024','WEEKLY',21500000,8900000,2,3,5,NULL,'08-01-2024 08:00',NULL),
 (15,'01-01-2024','07-01-2024','WEEKLY',9800000,4100000,6,9,2,NULL,'08-01-2024 08:00',NULL),
 (16,'08-01-2024','14-01-2024','WEEKLY',26400000,11000000,2,2,6,NULL,'15-01-2024 08:00',NULL),
 (17,'08-01-2024','14-01-2024','WEEKLY',35800000,20100000,1,1,7,NULL,'15-01-2024 08:00',NULL),
 (18,'08-01-2024','14-01-2024','WEEKLY',11200000,4700000,7,4,5,NULL,'15-01-2024 08:00',NULL),
 (19,'15-01-2024','21-01-2024','WEEKLY',27900000,15600000,1,2,7,NULL,'22-01-2024 08:00',NULL),
 (20,'15-01-2024','21-01-2024','WEEKLY',14300000,6000000,4,3,6,NULL,'22-01-2024 08:00',NULL),
 (21,'11-03-2024','17-03-2024','WEEKLY',33200000,30200000,1,1,8,NULL,'18-03-2024 08:00',NULL),
 (22,'18-03-2024','24-03-2024','WEEKLY',22500000,20500000,1,2,8,NULL,'25-03-2024 08:00',NULL),
 (23,'20-05-2024','26-05-2024','WEEKLY',91900000,12200000,1,1,NULL,7,'27-05-2024 08:00',NULL),
 (24,'27-05-2024','02-06-2024','WEEKLY',66500000,8800000,2,2,NULL,7,'03-06-2024 08:00',NULL),
 (25,'27-05-2024','02-06-2024','WEEKLY',8300000,1100000,9,30,NULL,5,'03-06-2024 08:00',NULL),
 (26,'02-04-2023','09-04-2023','WEEKLY',29400000,15300000,1,1,12,NULL,'10-04-2023 08:00',NULL),
 (27,'01-07-2023','31-12-2023','SEMI_ANNUALLY',68800000,32700000,NULL,NULL,12,NULL,'02-01-2024 08:00',NULL),
 (28,'30-12-2024','05-01-2025','WEEKLY',152500000,35400000,1,2,NULL,2,'06-01-2025 08:00',NULL),
 (29,'30-12-2024','05-01-2025','WEEKLY',14100000,2900000,8,6,NULL,1,'06-01-2025 08:00',NULL),
 (30,'01-01-2024','30-06-2024','SEMI_ANNUALLY',NULL,NULL,NULL,NULL,10,NULL,'02-07-2024 08:00',NULL);
SET search_path TO enterprise;
