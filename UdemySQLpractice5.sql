Select
	e.gender, AVG(s.salary) AS average_salary
FROM	
	employees e
		Join
	salaries s ON e.emp_no = s.emp_no
GROUP BY gender;


SELECT
	e.first_name,
    e.last_name,
    e.hire_date,
    m.from_date,
    d.dept_name
FROM
	employees e
		JOIN
	dept_manager m ON e.emp_no = m.emp_no
		JOIN
	departments d ON m.dept_no = d.dept_no
;

SELECT
	e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    t.from_date,
    d.dept_name
FROM
	employees e
		JOIN
	titles t ON e.emp_no = t.emp_no
		JOIN
	dept_manager dm ON t.emp_no = dm.emp_no
		JOIN
	departments d ON dm.dept_no = d.dept_no
WHERE t.title = 'Manager'
ORDER BY e.emp_no
;

# solution code
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    t.title = 'Manager'
ORDER BY e.emp_no;

select * from titles where title = 'Manager';
select * from dept_manager;


SELECT
	d.dept_name, AVG(salary)
FROM
	departments d
		JOIN
	dept_manager m ON d.dept_no = m.dept_no
		JOIN
	salaries s ON m.emp_no = s.emp_no
GROUP BY d.dept_name
;


SELECT
	e.gender, COUNT(dm.emp_no) AS number_of_managers
FROM
	employees e
		JOIN
	dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY e.gender
;


DROP TABLE IF EXISTS employees_dup;
CREATE TABLE employees_dup (
	emp_no int(11),
    birth_date date,
    first_name varchar(14),
    last_name varchar(16),
    gender enum('M', 'F'),
    hire_date date
	);
    
INSERT INTO employees_dup
SELECT
	e.*
FROM
	employees e
LIMIT 20;

select * from employees_dup;


INSERT INTO employees_dup VALUES
('10001', '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26');


SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM
	employees_dup e
WHERE
	e.emp_no = 10001
UNION ALL SELECT
	NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM
	dept_manager m;
    
    
SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM
	employees_dup e
WHERE
	e.emp_no = 10001
UNION SELECT
	NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM
	dept_manager m;
    
# exercise code

SELECT 
    *
FROM
    (SELECT 
        e.emp_no,
            e.first_name,
            e.last_name,
            NULL AS dept_no,
            NULL AS from_date
    FROM
        employees e
    WHERE
        last_name = 'Denis' UNION SELECT 
        NULL AS emp_no,
            NULL AS first_name,
            NULL AS last_name,
            dm.dept_no,
            dm.from_date
    FROM
        dept_manager dm) AS a
ORDER BY -a.emp_no asc;


USE employees;

SELECT
	e.first_name, e.last_name
FROM
	employees e
WHERE
	e.emp_no IN (SELECT
			dm.emp_no
		FROM
			dept_manager dm);
            
SELECT 
    *
FROM
    dept_manager;
            
            
SELECT
	dm.*
FROM
	dept_manager dm
WHERE
	dm.emp_no IN (SELECT
			e.emp_no
		FROM 
			employees e
		WHERE
			'1990-01-01' <= hire_date <= '1995-01-01');
            
# solution code
SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT 
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');
            
  
SELECT 
    emp_no
FROM
    employees
WHERE
    hire_date BETWEEN '1990-01-01' AND '1995-01-01';  
  
		
SELECT
	e.first_name, e.last_name
FROM
	employees e
WHERE
	EXISTS (SELECT
			*
		FROM
			dept_manager dm
		WHERE
			dm.emp_no = e.emp_no)
ORDER BY e.emp_no; # order by is more professional to use in outter query

SELECT
	*
FROM
	employees e
WHERE
	EXISTS (SELECT
			*
		FROM
			titles t
		WHERE
			e.emp_no = t.emp_no AND
			title = 'Assistant Engineer')
;

# solution code
SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles t
        WHERE
            t.emp_no = e.emp_no
                AND title = 'Assistant Engineer');
                
SELECT * from titles where title = 'Assistant Engineer';





SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;



DROP TABLE IF EXISTS emp_manager;

# (emp_no – integer of 11, not null; dept_no – CHAR of 4, null; manager_no – integer of 11, not null). 
CREATE TABLE emp_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);


Insert INTO emp_manager SELECT

U.*

FROM (

	#(A)
    SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 

UNION 
#(B) 
SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B

UNION 
#(C) 
SELECT 
    C.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no
    #ORDER BY e.emp_no
   ) AS C

UNION 
#(D)
SELECT 
    D.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no
    #ORDER BY e.emp_no
   ) AS D

) AS U;

SELECT * FROM emp_manager;


SELECT 
    *
FROM
    emp_manager
ORDER BY emp_manager.emp_no;


SELECT 
    e1.*
FROM
    emp_manager e1
        JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no;



SELECT 
    *
FROM
    dept_emp;
    
    
SELECT
	emp_no, from_date, to_date, COUNT(emp_no) AS Num
FROM
	dept_emp
GROUP BY emp_no
Having Num > 1;


CREATE OR REPLACE VIEW v_dept_emp_latest_date AS
    SELECT 
        emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM
        dept_emp
    GROUP BY emp_no;
    
    
SELECT 
        emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM
        dept_emp
    GROUP BY emp_no;


CREATE OR REPLACE VIEW v_dept_manager_avg_sal AS
    SELECT 
        ROUND(AVG(salary),2)
    FROM
        salaries s
            JOIN
        dept_manager d ON s.emp_no = d.emp_no;
		
        

		

