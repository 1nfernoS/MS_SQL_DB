CREATE DATABASE DB_Dentist
GO

USE DB_Dentist
GO
/**********************
Initial script to create all tables and constraints
**********************/
CREATE TABLE Discount (
    IdDiscount INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    NameDiscount NVARCHAR(25) NOT NULL,
    PercentDiscount DECIMAL(4,2) NOT NULL,
	ThresholdBonus DECIMAL(4,0) NOT NULL
)
GO
CREATE TABLE BonusCard (
    CardNum VARCHAR(12) PRIMARY KEY NOT NULL,
    IdDiscount INT FOREIGN KEY REFERENCES Discount(IdDiscount) NOT NULL,
	QtyBonus INT DEFAULT(0) NOT NULL 
)
GO
CREATE TABLE Client(
    IdClient INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    FirstName NVARCHAR(25) NOT NULL,
    LastName NVARCHAR(25) NOT NULL,
    MidName NVARCHAR(25) NOT NULL,
    Phone NVARCHAR(14) NULL,
    Gender CHAR(1) NOT NULL,
    Subscribe NVARCHAR(25) NOT NULL,
    CardNum VARCHAR(12) FOREIGN KEY REFERENCES BonusCard(CardNum) NOT NULL,
    IsPension BIT DEFAULT(0),
    IsDeleted BIT DEFAULT(0)
)
GO
CREATE TABLE PriceList (
    IdService INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    NameService NVARCHAR(25) NOT NULL,
    PriceService DECIMAL(7,2),
    IsDeleted BIT DEFAULT(0)
)
GO
CREATE TABLE Job (
    IdJob INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    NameJob NVARCHAR(25) NOT NULL,
    IsDeleted BIT DEFAULT(0)
)
GO
CREATE TABLE Citizenship (
    IdCitizenship INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    NameCitizenship NVARCHAR(25) NOT NULL,
)
GO
CREATE TABLE Employee (
    IdEmployee INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    FirstName NVARCHAR(25) NOT NULL,
    LastName NVARCHAR(25) NOT NULL,
    MidName NVARCHAR(25) NOT NULL,
    Gender CHAR(1) NOT NULL,
    IdCitezenship INT FOREIGN KEY REFERENCES Citizenship(IdCitizenship) NOT NULL,
    Age INT NOT NULL,
    Phone NVARCHAR(14) NOT NULL,
    IdJob INT FOREIGN KEY REFERENCES Job(IdJob) NOT NULL,
    HireDate DATE DEFAULT(GETDATE()),
    Salary DECIMAL(8,2),
    IsDeleted BIT DEFAULT(0)
)
GO
CREATE TABLE Reception (
    IdSession INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    IdEmployee INT FOREIGN KEY REFERENCES Employee(IdEmployee) NOT NULL,
    IdClient INT FOREIGN KEY REFERENCES Client(IdClient) NOT NULL,
    IdService INT FOREIGN KEY REFERENCES PriceList(IdService) NOT NULL,
    TimeSession DATETIME DEFAULT(GETDATE())
)
GO
CREATE TABLE [Provider] (
    IdProv INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    NameProv NVARCHAR(25) NOT NULL,
    Phone NVARCHAR(14) NOT NULL,
    Email NVARCHAR(25) NOT NULL,
    IsDeleted BIT DEFAULT(0)
)
GO
CREATE TABLE Supply (
    IdSupp INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    IdProv INT FOREIGN KEY REFERENCES [Provider](IdProv) NOT NULL,
    DateSupp DATETIME DEFAULT(GETDATE()),
    Employee INT FOREIGN KEY REFERENCES Employee(IdEmployee) NOT NULL,
)
GO
CREATE TABLE Medicaments (
    IdMed INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    NameMed NVARCHAR(25) NOT NULL,
    IdProvBy INT FOREIGN KEY REFERENCES [Provider](IdProv) NOT NULL,
    Price DECIMAL(8,2),
)
GO
CREATE TABLE Store (
    IdPos INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    IdMed INT FOREIGN KEY REFERENCES Medicaments(IdMed) NOT NULL,
    Qty INT NOT NULL,
    LastArr DATETIME DEFAULT(GETDATE()),
    IsDeleted BIT DEFAULT(0)
)
GO
CREATE TABLE SuppMed (
    IdSupp INT FOREIGN KEY REFERENCES Supply(IdSupp) NOT NULL,
    IdMed INT FOREIGN KEY REFERENCES Medicaments(IdMed) NOT NULL,
    Qty INT NOT NULL,
    PRIMARY KEY (IdSupp, IdMed)
)
GO
CREATE TABLE [Shift] (
    IdShift INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    IdEmployee INT FOREIGN KEY REFERENCES Employee(IdEmployee) NOT NULL,
    StartTime DATETIME DEFAULT(GETDATE()),
    EndTime DATETIME DEFAULT(NULL),
)
GO
CREATE TABLE ServMed (
	IdServMed INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	IdSession INT FOREIGN KEY REFERENCES Reception(IdSession) NOT NULL,
	IdMedicament INT FOREIGN KEY REFERENCES Medicaments(IdMed) NOT NULL,
	Qty INT DEFAULT(0) NOT NULL,
	Isdeleted BIT DEFAULT(0) NOT NULL
)
GO