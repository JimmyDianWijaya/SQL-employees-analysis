-- SQL Data Analysis Portfolio (Self-initiated)
/* 
Author Details:
Name: Jimmy Wijaya
Date: 15/02/2021
*/

-- let's start by ensuring we use the right database
USE employees;

-- Retrieving all female employees whose first name is Kellie
SELECT *
FROM employees
WHERE first_name = 'Kellie' AND gender = 'F';

-- Extract all employees named John, Mark or Jacob
SELECT *
FROM employees
WHERE first_name IN ('John', 'Mark', 'Jacob');

-- Extract all employees information, whose first name starts with 'Mark'
SELECT *
FROM employees
WHERE first_name LIKE ('Mark%');

-- Retrieve a list with all employees who have bee hired in the year 2000
SELECT *
FROM employees 
WHERE hire_date LIKE ('2000%');

-- Retrieve a list with all employees whose employee number is written with 5 chararcters, and starts with '1000'
SELECT *
FROM employees
WHERE emp_no LIKE ('_____') AND emp_no LIKE ('1000%');

-- Inserting a new department known as 'Business Analysis' and register it under dept_no 'd010'
INSERT INTO departments
VALUES ('d010', 'Business Analysis');
-- to check if the new data is inserted correctly
select *
from departments
order by dept_no;

-- update the title of emp_no 10163 to Senior Engineer 
UPDATE titles
SET title = 'Senior Engineer'
WHERE emp_no = 10163;
-- to double check previous update
select *
from titles
where emp_no = 10163;

-- what is the total amount of money spent on salaries for each employee starting after the 1st January 1997?
select emp_no, sum(salary) as total_money_spent
from salaries
where from_date > '1997-01-01'
group by emp_no;

-- Retrieve a list containing information about all managers' employee number, their names, department number, department name and hire date
SELECT b.emp_no, a.first_name, a.last_name, b.dept_no, c.dept_name, a.hire_date
FROM employees a
RIGHT JOIN dept_manager b
on a.emp_no = b.emp_no
LEFT JOIN departments c
ON b.dept_no = c.dept_no
ORDER BY hire_date;

-- Get all employee who is Assistant Engineer
SELECT DISTINCT a.emp_no, a.first_name, a.last_name
FROM employees a
WHERE EXISTS (SELECT b.emp_no FROM titles b WHERE title = 'Assistant Engineer' AND a.emp_no = b.emp_no);

-- Create a stored procedure to generate a certain employee salary information
DROP PROCEDURE IF EXISTS emp_salary;

DELIMITER $$

CREATE PROCEDURE emp_salary (IN p_emp_no INTEGER)
BEGIN
	SELECT e.first_name, e.last_name, b.salary, e.from_date, e.to_date
	FROM employees a
	INNER JOIN salaries b
	ON a.emp_no = b.emp_no
	WHERE e.emp_no = p_emp_no;
END$$ 
DELIMITER ;

-- create a function to generate the average salary of an employee
DROP FUNCTION IF EXISTS func_avg_emp_salary;

DELIMITER $$
CREATE FUNCTION func_avg_emp_salary (p_emp_no INT) RETURNS DECIMAL(10,2)
BEGIN
	DECLARE v_avg_salary DECIMAL(10,2);
    
	SELECT avg(b.salary) into v_avg_salary
	FROM employees a
	inner join salaries b
	on a.emp_no = b.emp_no
	where a.emp_no = p_emp_no
	group by a.emp_no;
    
    RETURN v_avg_salary;
END$$
DELIMITER ;



