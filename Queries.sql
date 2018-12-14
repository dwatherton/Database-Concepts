/*SQL Assignment 1*/

/*1.Retrieve the name and location of each project.*/
SELECT PNAME, PLOCATION
FROM PROJECT
ORDER BY PNUMBER;

/*2.Retrieve the names and relationship of dependents for the employee with SSN=123456789;*/
SELECT DEPENDENT_NAME, RELATIONSHIP
FROM DEPENDENT
WHERE ESSN = 123456789
ORDER BY DEPENDENT_NAME;

/*3.Retrieve the last name and birth date of male employees who work for department 5.*/
SELECT LNAME, BDATE
FROM EMPLOYEE
WHERE SEX = 'M' AND DNO = 5
ORDER BY SSN;

/*4.Retrieve the average salary and minimum salary of female employees.*/
SELECT AVG(SALARY), MIN(SALARY)
FROM EMPLOYEE
WHERE SEX = 'F';

/*5.For each employee who has dependents, list his/her SSN and the number of dependents he/she has.*/
SELECT SSN, COUNT(ESSN)
FROM EMPLOYEE, DEPENDENT
WHERE SSN = ESSN
GROUP BY SSN
ORDER BY SSN;

/*6.Retrieve the first names and last names of employees whose first names start with ‘J’.*/
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE FNAME LIKE 'J%'
ORDER BY FNAME;


/*SQL Assignment 2*/

/*1.Retrieve the SSNs of employees along with the number of projects they are working on.*/
SELECT ESSN, COUNT(*)
FROM WORKS_ON
GROUP BY ESSN
ORDER BY ESSN;

/*2.For each employee working on at least two projects, list their SSN and average project hours.*/
SELECT ESSN, AVG(HOURS)
FROM WORKS_ON
GROUP BY ESSN
HAVING COUNT(ESSN) >= 2
ORDER BY ESSN;

/*3.Retrieve the number of distinct employees that have dependents.*/
SELECT COUNT(DISTINCT ESSN) DISTINCT_EMPLOYEE_W_DEPENDENTS
FROM DEPENDENT;

/*4.Retrieve the names of employees who work on the project with pno=20.*/
SELECT FNAME, MINIT, LNAME
FROM EMPLOYEE, WORKS_ON
WHERE SSN = ESSN AND PNO = 20
ORDER BY FNAME;

/*5.(extra credit) For each department with at least two locations, retrieve the department number along with its locations.*/
SELECT DNUMBER, DLOCATION
FROM DEPT_LOCATIONS
WHERE DNUMBER IN (SELECT DNUMBER 
                  FROM DEPT_LOCATIONS 
                  GROUP BY DNUMBER 
                  HAVING COUNT(*)>=2);
/*OR Using Join Table on Department_Locations...*/
SELECT DISTINCT D.DNUMBER DEPARTMENT_NUMBER, D.DLOCATION LOCATIONS
FROM DEPT_LOCATIONS D, DEPT_LOCATIONS L
WHERE D.DNUMBER = L.DNUMBER AND D.DLOCATION != L.DLOCATION;
/*OR Using Join Table on Project_A and Project_B...*/
SELECT DISTINCT DNUMBER, DLOCATION
FROM DEPT_LOCATIONS, PROJECT A, PROJECT B
WHERE DNUMBER = A.DNUM AND (A.DNUM = B.DNUM AND A.PLOCATION != B.PLOCATION);


/*SQL Assignment 3*/

/* 1.For each employee having a dependent, retrieve the employee’s name along with his/her dependent name(s).*/
SELECT FNAME, MINIT, LNAME, DEPENDENT_NAME
FROM EMPLOYEE, DEPENDENT
WHERE SSN = ESSN
ORDER BY LNAME;

/*2.For each department, list its name along with the names of projects the department controls.*/
SELECT DNAME, PNAME
FROM DEPARTMENT, PROJECT
WHERE DNUMBER = DNUM
ORDER BY DNAME;

/*3.For each department, lists its name, manager’s name,and the names of projects it controls.*/
SELECT DNAME, FNAME, MINIT, LNAME, PNAME
FROM DEPARTMENT, EMPLOYEE, PROJECT
WHERE DNUMBER = DNUM AND MGR_SSN = SSN
ORDER BY DNAME;

/*4.For each employee, list his/her first name, last name,and his/her department manager’s name.*/
SELECT E.FNAME, E.LNAME, M.FNAME MANAGER_FNAME, M.LNAME MANAGER_LNAME
FROM EMPLOYEE E, EMPLOYEE M, DEPARTMENT
WHERE MGR_SSN = M.SSN AND DNUMBER = E.DNO
ORDER BY E.DNO;

/*5.For the department that controls more projects than any other department, retrieve its department number.*/
SELECT DNUM
FROM PROJECT
GROUP BY DNUM
HAVING COUNT(*) IN (SELECT MAX(COUNT(*))
                    FROM PROJECT
                    GROUP BY DNUM);


/*SQL Assignment 4*/

/*1.Retrieve the names of all employees whose supervisor’s SSN is 888665555.*/
SELECT FNAME, MINIT, LNAME
FROM EMPLOYEE
WHERE SUPER_SSN = 888665555;

/*2.For each department manager, retrieve his/her name along with the names of projects that he/she is working on.*/
SELECT FNAME, MINIT, LNAME, PNAME
FROM EMPLOYEE, DEPARTMENT, PROJECT, WORKS_ON
WHERE SSN = MGR_SSN AND SSN = ESSN AND PNO = PNUMBER
ORDER BY FNAME;

/*3.Retrieve the manager’s first and last name of the each department that locates in ‘Houston’.*/
SELECT FNAME, LNAME
FROM EMPLOYEE, DEPARTMENT D, DEPT_LOCATIONS L
WHERE MGR_SSN = SSN AND D.DNUMBER = L.DNUMBER AND DLOCATION = 'Houston'
ORDER BY SSN;

/*4.Find the SSNs of department managers who don’t have dependents.*/
SELECT MGR_SSN
FROM DEPARTMENT
MINUS
SELECT SSN
FROM EMPLOYEE, DEPARTMENT, DEPENDENT
WHERE MGR_SSN = SSN AND MGR_SSN = ESSN;

/*5.(Extra credit)Retrieve the first and last name of each department manager and the first and last name of his/her immediate supervisor.*/
SELECT E.FNAME MANAGER_FNAME, E.LNAME MANAGER_LNAME, S.FNAME SUPERVISOR_FNAME, S.LNAME SUPERVISOR_LNAME
FROM DEPARTMENT, EMPLOYEE E, EMPLOYEE S
WHERE MGR_SSN = E.SSN AND E.SUPER_SSN = S.SSN
ORDER BY E.FNAME;


/*SQL Review Exercise*/

/*1.Retrieve the first name, last name, and SSN of each employee and his/her dependent name(s).*/
SELECT FNAME, LNAME, SSN, DEPENDENT_NAME
FROM EMPLOYEE, DEPENDENT
WHERE SSN = ESSN
ORDER BY SSN;

/*2.For each project, retrieve its name, controlling department’s name, and the names of employees who work on the project.*/
SELECT PNAME, DNAME, FNAME, MINIT, LNAME
FROM PROJECT, DEPARTMENT, EMPLOYEE
WHERE DNO = DNUMBER AND DNUMBER = DNUM
ORDER BY PNAME;

/*3.Retrieve the names of employees who work on the project "Product X".*/
SELECT FNAME, MINIT, LNAME
FROM EMPLOYEE, WORKS_ON, PROJECT
WHERE SSN = ESSN AND PNO = PNUMBER AND PNAME = 'ProjectX'
ORDER BY FNAME;

/*4.Retrieve the NUMBER of employees who work on the project “Product X”.*/
SELECT COUNT(*) EMPLOYEES
FROM WORKS_ON, PROJECT
WHERE PNO = PNUMBER AND PNAME = 'ProjectX';

/*5.Retrieve the SSNs and names of employees who don’t have a dependent.*/
SELECT SSN, FNAME, MINIT, LNAME
FROM EMPLOYEE, DEPENDENT
MINUS
SELECT SSN, FNAME, MINIT, LNAME
FROM EMPLOYEE, DEPENDENT
WHERE SSN = ESSN
ORDER BY SSN;

/*6.Retrieve the names and SSNs of employees who have at least two dependents.*/
SELECT FNAME, MINIT, LNAME, SSN
FROM EMPLOYEE, DEPENDENT
WHERE SSN = ESSN
GROUP BY FNAME, MINIT, LNAME, SSN
HAVING COUNT(ESSN) >= 2;

/*7.Retrieve the names of employees who work on the projects of both “Product X” and “Product Y”.*/
SELECT FNAME, MINIT, LNAME
FROM EMPLOYEE, WORKS_ON, PROJECT
WHERE SSN = ESSN AND PNO = PNUMBER AND PNAME = 'ProjectX'
INTERSECT
SELECT FNAME, MINIT, LNAME
FROM EMPLOYEE, WORKS_ON, PROJECT
WHERE SSN = ESSN AND PNO = PNUMBER AND PNAME = 'ProjectY';

/*8.Retrieve the first name and last name of employees who has the highest salary.*/
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                 FROM EMPLOYEE);



/*Additional Queries*/

/*List the name of the department that controls the minimum number of projects*/
SELECT DNAME, COUNT(*)
FROM PROJECT, DEPARTMENT
WHERE DNUM = DNUMBER
GROUP BY DNAME
HAVING COUNT(*) IN (SELECT MIN(COUNT(*))
                    FROM PROJECT
                    GROUP BY DNUM);
                    
/*List the name of the project that has the maximum number of employees.*/                    
SELECT PNAME, COUNT(*)
FROM PROJECT, WORKS_ON
WHERE PNUMBER = PNO
GROUP BY PNAME
HAVING COUNT(*) IN (SELECT MAX(COUNT(*))
                    FROM WORKS_ON
                    GROUP BY PNO);

/*For each department located in Houston, list the department name and it's manager's name.*/
SELECT D.DNAME, E.FNAME, E.MINIT, E.LNAME
FROM DEPARTMENT D, EMPLOYEE E, DEPT_LOCATIONS L
WHERE D.DNUMBER = L.DNUMBER AND L.DLOCATION = 'Houston' AND D.MGR_SSN = E.SSN;

/*For each project, list its project number, project name, and the number of employees working on it.*/
SELECT P.PNUMBER PROJECT_NUMBER, P.PNAME PROJECT_NAME, COUNT(*) NUMBER_OF_EMPLOYEES
FROM PROJECT P, WORKS_ON W
WHERE P.PNUMBER = W.PNO
GROUP BY P.PNUMBER, P.PNAME;

/*List the name of departments that are located in both Houston and Sugarland.*/
SELECT DNAME
FROM DEPARTMENT D, DEPT_LOCATIONS L, DEPT_LOCATIONS K
WHERE D.DNUMBER = L.DNUMBER AND L.DNUMBER = K.DNUMBER AND L.DLOCATION = 'Houston' AND K.DLOCATION = 'Sugarland';
/*OR Using Set Operators...*/
SELECT DNAME
FROM DEPARTMENT D, DEPT_LOCATIONS L
WHERE D.DNUMBER = L.DNUMBER AND L.DLOCATION = 'Sugarland'
INTERSECT
SELECT DNAME
FROM DEPARTMENT D, DEPT_LOCATIONS L
WHERE D.DNUMBER = L.DNUMBER AND L.DLOCATION = 'Houston';
/*OR Using Nested Queries...*/
SELECT DNAME
FROM DEPARTMENT D, DEPT_LOCATIONS L
WHERE D.DNUMBER = L.DNUMBER AND L.DLOCATION = 'Sugarland' AND D.DNUMBER IN (SELECT DNUMBER
                                                                            FROM DEPT_LOCATIONS
                                                                            WHERE DLOCATION = 'Houston');

/*Find the name of employee who supervises more employees than any other supervisor*/
SELECT E.FNAME, E.MINIT, E.LNAME, COUNT(*) SUPERVISED_EMPLOYEES
FROM EMPLOYEE E, EMPLOYEE S
WHERE E.SSN = S.SUPER_SSN
GROUP BY E.FNAME, E.MINIT, E.LNAME
HAVING COUNT(*) IN (SELECT MAX(COUNT(*))
                    FROM EMPLOYEE
                    GROUP BY SUPER_SSN);
/*OR Using nested queries...*/
SELECT FNAME, MINIT, LNAME
FROM EMPLOYEE
WHERE SSN = (SELECT SUPER_SSN
             FROM EMPLOYEE
             GROUP BY SUPER_SSN
             HAVING COUNT(*) IN (SELECT MAX(COUNT(*))
                                 FROM EMPLOYEE
                                 GROUP BY SUPER_SSN));
                                 
/*Retrieve the names of projects that are controlled by the Research department.*/
SELECT PNAME
FROM PROJECT
WHERE DNUM IN (SELECT DNUMBER
                FROM DEPARTMENT
                WHERE DNAME = 'Research');

/*Retrieve the Essns of all employees who work on a same project as the employee ‘John Smith’.*/
SELECT DISTINCT ESSN
FROM WORKS_ON
WHERE PNO IN (SELECT PNO
                FROM WORKS_ON
                WHERE ESSN IN (SELECT SSN
                                FROM EMPLOYEE
                                WHERE FNAME = 'John' AND LNAME = 'Smith'));
                                
/*Retrieve the SSNs of employees whose salaries are not the lowest.*/                                        
SELECT SSN
FROM EMPLOYEE
WHERE SALARY > (SELECT MIN(SALARY)
                    FROM EMPLOYEE);

/*For the department that controls the project ‘Newbenefits’, retrieve its manager’s SSN.*/                    
SELECT MGR_SSN MANAGER_SSN
FROM DEPARTMENT
WHERE DNUMBER IN (SELECT DNUM
                    FROM PROJECT
                    WHERE PNAME = 'Newbenefits');
                                                           
/*For the department that controls the project ‘Newbenefits’, retrieve its manager’s SSN, first name, and last name.*/
SELECT SSN, FNAME, LNAME
FROM EMPLOYEE
WHERE SSN IN (SELECT MGR_SSN
                    FROM DEPARTMENT
                    WHERE DNUMBER IN (SELECT DNUM
                                        FROM PROJECT
                                        WHERE PNAME = 'Newbenefits'));

/*For each employee, list his/her name along with his/her department name.*/                                        
SELECT FNAME, LNAME, DNAME
FROM EMPLOYEE, DEPARTMENT
WHERE DNO = DNUMBER;

/*Retrieve the name and address of all employees who work for the ‘Research’ department.*/
SELECT FNAME, LNAME, ADDRESS
FROM EMPLOYEE
WHERE DNO IN (SELECT DNUMBER
                FROM DEPARTMENT
                WHERE DNAME = 'Research');
/*OR Using Join Table*/                
SELECT FNAME, LNAME, ADDRESS
FROM EMPLOYEE, DEPARTMENT
WHERE DNUMBER = DNO AND DNAME = 'Research';

/*For each employee working on some project, list their names.*/
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE SSN IN (SELECT ESSN
                FROM WORKS_ON
                WHERE ESSN = SSN);
/*OR Using Join Table*/
SELECT DISTINCT FNAME, LNAME
FROM EMPLOYEE, WORKS_ON
WHERE SSN = ESSN;

/*For each employee working on some project, list their names and project names.*/
SELECT DISTINCT FNAME, LNAME, PNAME
FROM EMPLOYEE, PROJECT, WORKS_ON
WHERE SSN = ESSN AND PNO = PNUMBER;

/*For each department, list its number, name, and location(s). WITHOUT USING ALIASING*/
SELECT DNAME, DEPARTMENT.DNUMBER, DLOCATION
FROM DEPARTMENT, DEPT_LOCATIONS
WHERE DEPARTMENT.DNUMBER = DEPT_LOCATIONS.DNUMBER;

/*For each department, list its number, name, and location(s). USING ALIASING*/
SELECT DNAME, D.DNUMBER, DLOCATION
FROM DEPARTMENT D, DEPT_LOCATIONS L
WHERE D.DNUMBER = L.DNUMBER;

/*List the department name, and manager SSN of all departments.*/
SELECT DNAME, MGR_SSN
FROM DEPARTMENT;

/*List all the tuples in DEPARTMENT table.*/
SELECT *
FROM DEPARTMENT;

/*Retrieve the birth date and address of the employee(s) whose name is ‘John B. Smith’.*/
SELECT BDATE, ADDRESS
FROM EMPLOYEE
WHERE FNAME = 'John'AND MINIT = 'B' AND LNAME = 'Smith';

/*For every employee who works more than 20 hours on a single project, list his/her SSN and project number.*/
SELECT ESSN, PNO
FROM WORKS_ON
WHERE HOURS > 20;

/*List the names of female employees who work for the department 4.*/
SELECT FNAME, MINIT, LNAME
FROM EMPLOYEE
WHERE SEX = 'F' AND DNO = 4;

/*List the salaries and names of female employees who either make more than $40,000 or less than $20,000 a year.*/
SELECT SALARY, FNAME, MINIT, LNAME
FROM EMPLOYEE
WHERE SEX = 'F' AND (SALARY > 40000 OR SALARY < 20000);

/*list the name and location of projects that are NOT controlled by department 5.*/
SELECT PNAME, PLOCATION
FROM PROJECT
WHERE DNUM <> 5;

/*For employees, who work on a project between 30 to 40 hours,  list their SSNs and Pno of projects that they are working on.*/
SELECT ESSN, PNO
FROM WORKS_ON
WHERE HOURS >= 30 AND HOURS <= 40;

/*Retrieve all employees whose address is in Houston, Texas.*/
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE ADDRESS LIKE '%Houston, TX';

/*For each project, list the project number and the total number of employees working on it.*/
SELECT PNO, COUNT(*)
FROM WORKS_ON
GROUP BY PNO;

/*For each employee working on more than one project, retrieve their SSNs and  their total project hours.*/
SELECT ESSN, SUM(HOURS)
FROM WORKS_ON
GROUP BY ESSN
HAVING COUNT(*) > 1;

/*Retrieve the SSNs of employees who work on a project controlled by department 1.*/
SELECT ESSN
FROM WORKS_ON
WHERE PNO IN (SELECT PNUMBER 
                FROM PROJECT
                WHERE DNUM = 1);
                                
/*For each department, list the department number and number of projects it controls.*/                
SELECT DNUMBER, COUNT(*) 
FROM DEPARTMENT
WHERE DNUMBER IN (SELECT DNUM
                    FROM PROJECT
                    WHERE DNUMBER = DNUM)
GROUP BY DNUMBER;

/*For each department manager, list his/her SSN and number of projects he/she is working on.*/
SELECT ESSN, COUNT(*)
FROM WORKS_ON
WHERE ESSN IN (SELECT MGR_SSN
                FROM DEPARTMENT
                WHERE ESSN = MGR_SSN)
GROUP BY ESSN;                    

/*List the names, department numbers, and SSNs of department managers.*/
SELECT FNAME, LNAME, DNO, SSN
FROM EMPLOYEE
WHERE SSN IN (SELECT MGR_SSN
                FROM DEPARTMENT
                WHERE SSN = MGR_SSN);

/*For every project located in ‘Stafford’, list the project number, the controlling department number, and the department manager’s last name, address, and birth date.*/
SELECT PNUMBER, DNUM, LNAME, ADDRESS, BDATE
FROM PROJECT, DEPARTMENT, EMPLOYEE
WHERE DNUM = DNUMBER AND MGR_SSN = SSN AND PLOCATION = 'Stafford';

/*Find each employees name and department number.*/
SELECT DISTINCT FNAME, LNAME, DNUM
FROM EMPLOYEE, PROJECT
WHERE DNO = DNUM;

/*For each employee list their name, and the name of their supervisor.*/
SELECT E.FNAME, E.LNAME, S.FNAME, S.LNAME
FROM EMPLOYEE E, EMPLOYEE S
WHERE E.SUPER_SSN = S.SSN;

/*For each employee, list their name, address, birth date as well as the project number and department number of each project they work on.*/
SELECT FNAME, LNAME, ADDRESS, BDATE, PNUMBER, DNUM
FROM PROJECT, DEPARTMENT, EMPLOYEE
WHERE DNUM = DNUMBER AND MGR_SSN = SSN AND PLOCATION = 'Stafford';

/*List the employee ssn's of all employees that work on both project number 1 and project number 2.*/
SELECT DISTINCT W1.ESSN
FROM WORKS_ON W1, WORKS_ON W2
WHERE W1.ESSN = W2.ESSN AND W1.PNO = 1 AND W2.PNO = 2;

/*OR Using the INTERSECT operator...*/
SELECT ESSN
FROM WORKS_ON
WHERE PNO = 1 INTERSECT (SELECT ESSN
                    FROM WORKS_ON
                    WHERE PNO = 2);

/*List the ssn of each employee who is not a supervisor.*/
SELECT SSN
FROM EMPLOYEE
MINUS
SELECT SUPER_SSN
FROM EMPLOYEE;

/*List the first and last name of each employee who is not a manager.*/
SELECT FNAME, LNAME
FROM EMPLOYEE
MINUS
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE SSN IN (SELECT MGR_SSN
                FROM DEPARTMENT);
/*OR Using the MINUS operator with Join Table.*/
SELECT FNAME, LNAME
FROM EMPLOYEE
MINUS
SELECT FNAME, LNAME
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.SSN = D.MGR_SSN;
/*OR Using the NOT IN operator with nested query.*/
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE SSN NOT IN (SELECT MGR_SSN 
                    FROM DEPARTMENT);

/*For each project, list it's name, location, and controlling department name.*/
SELECT PNAME, PLOCATION ,DNAME
FROM PROJECT P, DEPARTMENT D
WHERE P.DNUM = D.DNUMBER;

/*For each deparment list it's name and location.*/
SELECT DNAME, DLOCATION
FROM (DEPARTMENT NATURAL JOIN DEPT_LOCATIONS);

/*List the total salary, max salary, minimum salary, and average salary of each employee who works for the department named 'Research'.*/
SELECT SUM(SALARY), MAX(SALARY), MIN(SALARY), AVG(SALARY)
FROM EMPLOYEE, DEPARTMENT
WHERE DNO = DNUMBER AND DNAME = 'Research';

/*List the ssn and name of each employee with at least 2 dependents.*/
SELECT SSN, FNAME, LNAME
FROM DEPENDENT, EMPLOYEE
WHERE SSN = ESSN
GROUP BY SSN, FNAME, LNAME 
HAVING COUNT(*) >= 2;

/*List the name and ssn of each employee who supervises at least 1 other employee.*/
SELECT E.FNAME, E.LNAME, E.SSN
FROM EMPLOYEE E, EMPLOYEE S
WHERE E.SSN = S.SUPER_SSN
GROUP BY E.FNAME, E.LNAME, E.SSN
HAVING COUNT(*) >= 1;
/*OR Using a nested query...*/
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE SSN IN (SELECT SUPER_SSN
               FROM EMPLOYEE
               GROUP BY SUPER_SSN
               HAVING COUNT(*) >= 1);

/*For each employee working on a project, list the project number and the employees ssn.*/
SELECT PNUMBER, ESSN
FROM PROJECT, WORKS_ON
WHERE PNUMBER = PNO
ORDER BY PNUMBER;