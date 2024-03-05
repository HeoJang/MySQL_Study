USE employees;

DROP PROCEDURE IF EXISTS select_employees;

DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN

		SELECT * FROM employees
        LIMIT 1000;

END$$

DELIMITER ;

CALL employees.select_employees();

CALL select_employees();

DROP PROCEDURE IF EXISTS avg_sal_employees;


DELIMITER $$
CREATE PROCEDURE avg_sal_employees()
BEGIN

		SELECT 
			AVG(salary)
        FROM 
			salaries s
				JOIN
                employees e ON s.emp_no = e.emp_no;

END$$

DELIMITER ;

CALL avg_sal_employees();


DROP PROCEDURE select_employees;


DROP PROCEDURE IF EXISTS emp_salary;

DELIMITER $$
USE employees $$
CREATE PROCEDURE emp_salary(IN p_emp_no INTEGER)
BEGIN
SELECT
	e.first_name, e.last_name, s.salary, s.from_date, s.to_date
FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no;
END$$

DELIMITER ; 



DROP PROCEDURE IF EXISTS emp_avg_salary;

DELIMITER $$
USE employees $$
CREATE PROCEDURE emp_avg_salary(IN p_emp_no INTEGER)
BEGIN
SELECT
	e.first_name, e.last_name, AVG(s.salary)
FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no
GROUP BY e.emp_no;
END$$

DELIMITER ; 


CALL emp_avg_salary(11300);




DROP PROCEDURE IF EXISTS emp_avg_salary_out;

DELIMITER $$
USE employees $$
CREATE PROCEDURE emp_avg_salary_out(IN p_emp_no INTEGER, OUT p_avg_salary DECIMAL(10, 2))
BEGIN
SELECT
	AVG(s.salary)
INTO p_avg_salary FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no
GROUP BY e.emp_no;
END$$

DELIMITER ; 




DROP PROCEDURE IF EXISTS emp_info;

DELIMITER $$
USE employees $$
CREATE PROCEDURE emp_info(IN p_first_name VARCHAR(14), IN p_last_name VARCHAR(16), OUT p_emp_no INTEGER)
BEGIN
SELECT
	e.emp_no
INTO p_emp_no FROM
	employees e
WHERE
	e.first_name = p_first_name AND e.last_name = p_last_name
GROUP BY e.emp_no;
END$$

DELIMITER ; 

SELECT * FROM employees WHERE first_name = 'Georgi' AND last_name = 'Facello';
#CALL emp_info(Georgi, Facello, @p_emp_no); 



SET @v_avg_salary = 0;
CALL employees.emp_avg_salary_out(11300, @v_avg_salary);
SELECT @v_avg_salary;

SET @v_emp_no = 0;
CALL employees.emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;
SELECT emp_no, first_name FROM employees WHERE first_name = 'Aruna' AND last_name = 'Journel';


DELIMITER $$
CREATE FUNCTION f_emp_avg_salary (p_emp_no INTEGER) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN

DECLARE v_avg_salary DECIMAL(10, 2);

SELECT
	AVG(s.salary)
INTO v_avg_salary FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no;
    
RETURN v_avg_salary;

END$$

DELIMITER ;

SELECT f_emp_avg_salary(11300);




DELIMITER $$
CREATE FUNCTION emp_info(p_first_name VARCHAR(16), p_last_name VARCHAR(16)) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN

DECLARE v_salary DECIMAL(10, 2);
DECLARE v_max_from_date DATE;

SELECT
	MAX(from_date)
INTO v_max_from_date FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.first_name = p_first_name AND e.last_name = p_last_name;
    

SELECT
	s.salary
INTO v_salary FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.first_name = p_first_name AND e.last_name = p_last_name AND s.from_date = v_max_from_date;
    
RETURN v_salary;

END$$

DELIMITER ;

SELECT emp_info('Aruna', 'Journel');




DELIMITER $$

CREATE TRIGGER trig_hire_date
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN 
	IF NEW.hire_date > DATE_FORMAT(SYSDATE(), '%y-%m-%d') THEN  #SELECT DATE_FORMAT(SYSDATE(), '%y-%m-%d') as today;
		SET NEW.hire_date = DATE_FORMAT(SYSDATE(), '%y-%m-%d'); 
	END IF; 
END $$

DELIMITER ;



INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');

SELECT 
    *
FROM
    employees
ORDER BY emp_no DESC;


SELECT 
    *
FROM
    employees
WHERE
    hire_date > '2000-01-01';

CREATE INDEX i_hire_date ON employees(hire_date);

drop index i_hire_date ON employees;



SELECT 
    *
FROM
    salaries
WHERE
    salary > 89000;
    
CREATE INDEX i_salary ON salaries(salary);


SELECT
	e.emp_no, 
    e.first_name, 
    e.last_name,
    CASE
		WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
	END AS is_manager
FROM
	employees e 
		LEFT JOIN
	dept_manager dm ON e.emp_no = dm.emp_no
WHERE
	e.emp_no > 109990;
    
    
    
SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_diff,
    CASE
		WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'salary raise > 30,000'
        ELSE 'salary raise <= 30,000'
	END AS sal_diff_higher_30000
FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no;



SELECT
	dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_diff,
    CASE
		WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'H'
        ELSE 'L'
	END AS sal_diff_higher_30000
FROM
	employees e
		JOIN
	salaries s ON e.emp_no = s.emp_no
		JOIN
	dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY e.emp_no;

select * from dept_manager;
select * from dept_emp;


SELECT
	e.emp_no,
    e.first_name,
    e.last_name,
    CASE
		WHEN MAX(de.to_date) < DATE_FORMAT(SYSDATE(), '%y-%m-%d') THEN 'Not an employee anymore'
        ELSE 'Is still employed'
	END AS is_still_working
FROM
	employees e
		JOIN
	dept_emp de ON e.emp_no = de.emp_no
GROUP BY e.emp_no
LIMIT 100;



SELECT
	emp_no,
    salary,
    row_number() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num
FROM
	salaries;



SELECT
	emp_no,
    salary,
    ROW_NUMBER() OVER () AS row_num1,
    ROW_NUMBER() OVER (PARTITION BY emp_no) AS row_num2,
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num3,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num4
FROM
	salaries;
    
    
    
SELECT
	dm.emp_no,
    #dm.dept_no,
    salary,
    row_number() OVER () AS row_num1,
    row_number() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num2
FROM
	dept_manager dm
		JOIN
	salaries s ON dm.emp_no = s.emp_no
    ORDER BY row_num1, emp_no, salary ASC;
    
    
    
SELECT
	dm.emp_no,
    salary,
    #row_number() OVER () AS row_num1,
    row_number() OVER (PARTITION BY emp_no ORDER BY salary ASC) AS row_num2,
    row_number() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num3
    
FROM
	dept_manager dm
		JOIN
	salaries s ON dm.emp_no = s.emp_no
    #ORDER BY row_num1, emp_no, salary ASC
    ;
    

SELECT
	emp_no,
    first_name,
    ROW_NUMBER() OVER w AS first_name_ranking_asc
FROM
	employees
WINDOW w AS(PARTITION BY first_name ORDER BY emp_no ASC); 

SELECT
	a.emp_no,
    a.salary AS min_salary
FROM(
	SELECT
		emp_no,
		salary,
		ROW_NUMBER() OVER w AS individual_salary
	FROM
		salaries
	WINDOW w AS(PARTITION BY emp_no ORDER BY salary)) AS a
WHERE
	a.individual_salary = 1;
    
    
#solution exercise1
SELECT a.emp_no,

       MIN(salary) AS min_salary FROM (

SELECT

emp_no, salary, ROW_NUMBER() OVER w AS row_num

FROM

salaries

WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a

GROUP BY emp_no;

    
#exercise3 : without window funciton
SELECT
	emp_no,
    MIN(salary)
FROM
	salaries
GROUP BY emp_no;

#exercise4
SELECT a.emp_no,

a.salary as min_salary FROM (

SELECT

emp_no, salary, ROW_NUMBER() OVER w AS row_num

FROM

salaries

WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a

WHERE a.row_num=1;
    
    

SELECT 
	emp_no, (COUNT(salary) - COUNT(DISTINCT salary)) as diff
FROM
	salaries
GROUP BY emp_no
HAVING diff > 0
ORDER BY emp_no;

SELECT 
	emp_no, salary, DENSE_RANK() OVER w AS rank_num
FROM
	salaries
WHERE emp_no = 11839
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);
    
#exercise1
SELECT 
	emp_no, salary, ROW_NUMBER() OVER w AS rank_num
FROM
	salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

#exercise2
SELECT 
	dm.emp_no, COUNT(salary) AS num_of_contrats
FROM
	salaries s
		JOIN dept_manager dm ON s.emp_no = dm.emp_no
GROUP BY dm.emp_no
ORDER BY dm.emp_no;

#exercise3
SELECT
	emp_no, salary, DENSE_RANK() OVER w AS rank_10560
FROM
	salaries
WHERE emp_no = 10560
WINDOW w AS (ORDER BY salary DESC);

    
    
SELECT
	d.dept_no,
    d.dept_name,
    dm.emp_no,
    RANK() OVER w AS department_salary_ranking,
    s.salary,
    s.from_date AS salary_from_date,
    s.to_date AS salary_to_date,
    dm.from_date AS dept_manager_from_date,
    dm.to_date AS dept_manager_to_date
FROM
	dept_manager dm
		JOIN
	salaries s ON dm.emp_no = s.emp_no
		AND s.from_date BETWEEN dm.from_date AND dm.to_date
        AND s.to_date BETWEEN dm.from_date AND dm.to_date
		JOIN
	departments d ON d.dept_no = dm.dept_no
WINDOW w AS (PARTITION BY dm.dept_no ORDER BY s.salary DESC);


#exercise 1
SELECT
	e.emp_no,
    s.salary,
    RANK() OVER w AS salary_ranking
FROM
	employees e
		JOIN
	salaries s ON s.emp_no = e.emp_no
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w AS (PARTITION BY e.emp_no ORDER BY s.salary DESC);
    
    
#exercise 2
SELECT
	e.emp_no,
    DENSE_RANK() OVER w AS salary_ranking,
    s.salary,
    e.hire_date,
    s.from_date,
    YEAR(s.from_date) - YEAR(e.hire_date) AS contract_years_from_start
FROM
	employees e
		JOIN
	salaries s ON s.emp_no = e.emp_no # AND YEAR(s.from_date) - YEAR(e.hire_date) >= 5
    AND YEAR(s.from_date) - YEAR(e.hire_date) >= 5
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w AS (PARTITION BY e.emp_no ORDER BY s.salary DESC);
    
    
    
    
    
    


