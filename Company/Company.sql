-- Tabela Department
CREATE TABLE Department (
    Dnumber INT AUTO_INCREMENT,
    Dname VARCHAR(100) NOT NULL,
    Mgr_ssn INT,
    Mgr_start_date DATE,
    Dlocation VARCHAR(100),
    PRIMARY KEY (Dnumber)
);

-- Tabela Employee
CREATE TABLE Employee (
    Ssn INT,
    Fname VARCHAR(50),
    Minit CHAR(1),
    Lname VARCHAR(50),
    Bdate DATE,
    Address VARCHAR(100),
    Sex CHAR(1),
    Salary FLOAT,
    Super_ssn INT,
    Dno INT,
    PRIMARY KEY (Ssn),
    FOREIGN KEY (Super_ssn) REFERENCES Employee(Ssn) ON DELETE SET NULL,
    FOREIGN KEY (Dno) REFERENCES Department(Dnumber) ON DELETE SET NULL
);

-- Tabela Dependent
CREATE TABLE Dependent (
    Essn INT,
    Dependent_name VARCHAR(50),
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(50),
    PRIMARY KEY (Essn, Dependent_name),
    FOREIGN KEY (Essn) REFERENCES Employee(Ssn) ON DELETE CASCADE
);

-- Tabela Project
CREATE TABLE Project (
    Pnumber INT AUTO_INCREMENT,
    Pname VARCHAR(100),
    Plocation VARCHAR(100),
    Dnum INT,
    PRIMARY KEY (Pnumber),
    FOREIGN KEY (Dnum) REFERENCES Department(Dnumber)
);

-- Tabela intermediária para relacionamento muitos-para-muitos entre Employee e Project
CREATE TABLE Works_On (
    Essn INT,
    Pno INT,
    Hours FLOAT,
    PRIMARY KEY (Essn, Pno),
    FOREIGN KEY (Essn) REFERENCES Employee(Ssn) ON DELETE CASCADE,
    FOREIGN KEY (Pno) REFERENCES Project(Pnumber) ON DELETE CASCADE
);

--Procedure p/ inserir Employee
DELIMITER $$

CREATE PROCEDURE InsertEmployee (
    IN p_Fname VARCHAR(50),
    IN p_Minit CHAR(1),
    IN p_Lname VARCHAR(50),
    IN p_Ssn INT,
    IN p_Bdate DATE,
    IN p_Address VARCHAR(100),
    IN p_Sex CHAR(1),
    IN p_Salary FLOAT,
    IN p_Super_ssn INT,
    IN p_Dno INT
)
BEGIN
    INSERT INTO Employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
    VALUES (p_Fname, p_Minit, p_Lname, p_Ssn, p_Bdate, p_Address, p_Sex, p_Salary, p_Super_ssn, p_Dno);
END$$

DELIMITER ;

--Procedure p/ alterar Employee
DELIMITER $$

CREATE PROCEDURE UpdateEmployee (
    IN p_Ssn INT,
    IN p_Fname VARCHAR(50),
    IN p_Minit CHAR(1),
    IN p_Lname VARCHAR(50),
    IN p_Bdate DATE,
    IN p_Address VARCHAR(100),
    IN p_Sex CHAR(1),
    IN p_Salary FLOAT,
    IN p_Super_ssn INT,
    IN p_Dno INT
)
BEGIN
    UPDATE Employee
    SET Fname = p_Fname, Minit = p_Minit, Lname = p_Lname, Bdate = p_Bdate,
        Address = p_Address, Sex = p_Sex, Salary = p_Salary, Super_ssn = p_Super_ssn, Dno = p_Dno
    WHERE Ssn = p_Ssn;
END$$

DELIMITER ;

-- Procedure p/ deletar Employee
DELIMITER $$

CREATE PROCEDURE DeleteEmployee (
    IN p_Ssn INT
)
BEGIN
    DELETE FROM Employee WHERE Ssn = p_Ssn;
END$$

DELIMITER ;

-- Index nome composto
CREATE INDEX idx_employee_name ON Employee (Fname, Minit, Lname);


-- Procedure p/ procurar Employee pelo nome composto
DELIMITER $$

CREATE PROCEDURE SelectEmployeeByName (
    IN p_Fname VARCHAR(50),
    IN p_Minit CHAR(1),
    IN p_Lname VARCHAR(50)
)
BEGIN
    SELECT * FROM Employee
    WHERE Fname = p_Fname
      AND Minit = p_Minit
      AND Lname = p_Lname;
END$$

DELIMITER ;

-- Index p/ nome do department
CREATE INDEX idx_department_name ON Department (Dname);

-- Procedure p/ consultar o department com mas employee
DELIMITER $$

CREATE PROCEDURE SelectMostPopulatedDepartmentWithNameFilter(
    IN p_Dname VARCHAR(100)
)
BEGIN
    SELECT D.Dname, COUNT(E.Ssn) AS EmployeeCount
    FROM Department D
    LEFT JOIN Employee E ON D.Dnumber = E.Dno
    WHERE D.Dname LIKE CONCAT('%', p_Dname, '%')
    GROUP BY D.Dname
    ORDER BY EmployeeCount DESC
    LIMIT 1;
END$$

DELIMITER ;

-- Procedure p/ consultar o department por cidade
DELIMITER $$

CREATE PROCEDURE SelectDepartmentsByCity (
    IN p_City VARCHAR(100)
)
BEGIN
    SELECT D.Dname, D.Dnumber, D.Mgr_ssn, D.Mgr_start_date, D.Dlocation
    FROM Department D
    WHERE D.Dlocation LIKE CONCAT('%', p_City, '%');
END$$

DELIMITER ;

-- Index Dno do Employee
CREATE INDEX idx_employee_dno ON Employee (Dno);

-- Procedure p/ consultar consultar a relação quantidade de employee - department
DELIMITER $$

CREATE PROCEDURE GetEmployeeCountByDepartment()
BEGIN
    SELECT D.Dname, COUNT(E.Ssn) AS EmployeeCount
    FROM Department D
    LEFT JOIN Employee E ON D.Dnumber = E.Dno
    GROUP BY D.Dname
    ORDER BY EmployeeCount DESC;
END$$

DELIMITER ;