USE employees;

INSERT INTO employees
(
	emp_no,
    birth_date,
    first_name,
    last_name,
    gender,
    hire_date
) VALUES
(
	999901,
    '1986-04-21',
    'John',
    'Smith',
    'M',
    '2011-01-01'
);

SELECT 
    *
FROM
    employees
WHERE
    emp_no = 999901;
    
    
UPDATE employees
SET
	first_name = 'Stella',
    last_name = 'Parkinson',
    birth_date = '1990-12-31',
    gender = 'F'
WHERE
	emp_no = 999901;
    
    
CREATE TABLE department_dup (
    dept_no CHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL
);

INSERT INTO department_dup (dept_no, dept_name)
SELECT 
    *
FROM
    departments;
    
SELECT
	*
FROM
	department_dup;
    
    
SELECT 
    *
FROM
    department_dup
ORDER BY dept_no;

SELECT 
    *
FROM
    departments
ORDER BY dept_no;

COMMIT;


UPDATE department_dup 
SET 
    dept_no = 'd011',
    dept_name = 'Quality Control';
    
    
ROLLBACK;

COMMIT;

UPDATE departments
SET 
    dept_name = 'Data Analysis'
WHERE
    dept_no = 'd010';
    
    
SELECT 
    *
FROM
    employees

WHERE
    emp_no = 999903;
    
    
DELETE FROM employees 
WHERE
    emp_no = 999903;
    
    
ROLLBACK;

DELETE FROM departments 
WHERE
    dept_no = 'd010';
    
    
    
SELECT 
    COUNT(DISTINCT dept_no)
FROM
    dept_emp;
    
    
SELECT 
    SUM(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';
    
    
SELECT 
    MIN(emp_no)
FROM
    employees;
    
    
SELECT 
    MAX(emp_no)
FROM
    employees;
    
    
SELECT 
    AVG(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';
    
    
SELECT 
    ROUND(AVG(salary), 2)
FROM
    salaries
WHERE
    from_date > '1997-01-01';
    

SELECT 
    *
FROM
    department_dup;
    
ALTER TABLE department_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;


INSERT INTO department_dup(dept_no) VALUES ('d010'), ('d011');

SELECT 
    *
FROM
    department_dup
ORDER BY dept_no ASC;


ALTER TABLE employees.department_dup
ADD COLUMN dept_manager VARCHAR(255) NULL AFTER dept_name;

DELETE FROM department_dup 
WHERE
    dept_no = 'd011';
    

COMMIT;


SELECT 
    dept_no,
    IFNULL(dept_name,
            'Department name not provided') AS dept_name
FROM
    department_dup;
    
    
SELECT 
    dept_no,
    COALESCE(dept_name,
            'Department name not provided') AS dept_name
FROM
    department_dup;
    
    
SELECT 
    dept_no,
    dept_name,
    COALESCE(dept_manager, dept_name, 'N/A') AS dept_manager
FROM
    department_dup
ORDER BY dept_no ASC;


SELECT
	dept_no,
    dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
	department_dup
ORDER BY dept_no ASC;


SELECT 
    IFNULL(dept_no, 'N/A') AS dept_no,
    IFNULL(dept_name, 'Department name not provided') AS dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    department_dup
ORDER BY dept_no ASC;



SELECT 
    *
FROM
    department_dup;
    
    
ALTER TABLE department_dup
DROP Column dept_manager;


ALTER TABLE department_dup
CHANGE COLUMN dept_no dept_no CHAR(4) NULL;

ALTER TABLE department_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;


# from here, run later

INSERT INTO department_dup (dept_name)
VALUES (
	
    'Public Relations'
    );
    
DELETE FROM department_dup
WHERE
    dept_no = 'd002';
    

INSERT INTO department_dup
(
	dept_no
)
VALUES ('d010'), ('d011');



# exercise code
DROP TABLE IF EXISTS dept_manager_dup;

CREATE TABLE dept_manager_dup (

  emp_no int(11) NOT NULL,

  dept_no char(4) NULL,

  from_date date NOT NULL,

  to_date date NULL

  );

 SELECT 
    *
FROM
    dept_manager_dup;

INSERT INTO dept_manager_dup

select * from dept_manager;

 

INSERT INTO dept_manager_dup (emp_no, from_date)

VALUES                (999904, '2017-01-01'),

                                (999905, '2017-01-01'),

                               (999906, '2017-01-01'),

                               (999907, '2017-01-01');

 

DELETE FROM dept_manager_dup

WHERE

    dept_no = 'd001';



SELECT 
    *
FROM
    dept_manager_dup
ORDER BY dept_no;

SELECT 
    *
FROM
    department_dup
ORDER BY dept_no;


SELECT m.dept_no, m.emp_no, d.dept_name
FROM
	dept_manager_dup m
		JOIN
	department_dup d ON m.dept_no = d.dept_no
GROUP BY m.emp_no
ORDER BY m.dept_no;


SELECT m.emp_no, m.first_name, m.last_name, d.dept_no, m.hire_date
FROM
	employees m
JOIN
	dept_manager_dup d ON m.emp_no = d.emp_no
ORDER BY m.emp_no;



INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');

INSERT INTO department_dup
VALUES ('d009', 'Customer Service');


SELECT 
    *
FROM
    dept_manager_dup
ORDER BY dept_no ASC;


SELECT 
    *
FROM
    department_dup
ORDER BY dept_no ASC;


# remove the duplicates from the two tables
DELETE FROM dept_manager_dup
WHERE emp_no = '110228';

DELETE FROM department_dup
WHERE dept_no = 'd009';

# add back the initial records
INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');

INSERT INTO department_dup
VALUES ('d009', 'Customer Service');


# LEFT JOIN
SELECT
	m.dept_no, m.emp_no, d.dept_name
FROM
	dept_manager_dup m
		LEFT JOIN
	department_dup d ON m.dept_no = d.dept_no
GROUP BY m.emp_no
ORDER BY m.dept_no;
        
        
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    dm.dept_no,
    dm.from_date
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
WHERE
    e.last_name = 'Markovitch'
ORDER BY dm.dept_no DESC , e.emp_no;


SELECT 
    e.emp_no, e.first_name, e.last_name, m.dept_no, e.hire_date
FROM
    employees e,
    dept_manager m
WHERE
    e.emp_no = m.emp_no;
    
    
set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');



SELECT
	e.first_name,
    e.last_name,
    e.hire_date,
    t.title
FROM
	employees e
		JOIN
	titles t ON e.emp_no = t.emp_no
WHERE
	first_name = 'Margareta' AND # first_name = VS e.first_name ???
    last_name = 'Markovitch' # & VS AND ???
ORDER BY e.emp_no
;

SELECT
	dm.*, d.*
FROM
	dept_manager dm
		CROSS JOIN
	departments d
ORDER BY dm.emp_no, d.dept_no; # 216 rows (dm X d) Cartesian product

Select * from dept_manager; # 24 rows
select * from departments; # 9rows 		24 * 9 = 216

SELECT
	dm.*, d.*
FROM
	dept_manager dm,
    departments d
ORDER BY dm.emp_no, d.dept_no;


SELECT
	e.*, d.*
FROM
	departments d
		CROSS JOIN
	dept_manager dm
		JOIN
	employees e ON dm.emp_no = e.emp_no
WHERE
	d.dept_no <> dm.dept_no
ORDER BY dm.emp_no, d.dept_no;


SELECT
	d.*, dm.*
FROM
	dept_manager dm
		CROSS JOIN
	departments d
WHERE d.dept_no = 'd009'
ORDER BY dm.emp_no;

# solution code
SELECT 
    dm.*, d.*
FROM
    departments d
        CROSS JOIN
    dept_manager dm
WHERE
    d.dept_no = 'd009'
ORDER BY d.dept_no;


SELECT 
    e.*, d.*
FROM
    employees e
        CROSS JOIN
    departments d
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no , d.dept_name;

# solution code
SELECT 
    e.*, d.*
FROM
    employees e
        CROSS JOIN
    departments d
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no , d.dept_name;