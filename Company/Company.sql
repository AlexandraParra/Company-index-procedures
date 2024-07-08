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