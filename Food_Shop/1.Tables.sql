CREATE DATABASE SampleDB
GO

USE SampleDB
GO

/**
		Script to setup DB tables, types and FKs


		CHANGELOG
		--MOVED ALTER COLUMNS AND TYPE TO CREATE TABLE

**/

	--Type
CREATE TYPE [dbo].[phone]
FROM varchar(14) NOT NULL 

/**
		Creating Tables
**/

CREATE TABLE Product(
	IdProduct INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Description] NVARCHAR(30) NOT NULL,
	BuyPrice DECIMAL (10,2) NOT NULL
)
GO

CREATE TABLE [Provider](
	IdProvider INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	NameProv NVARCHAR(100) NOT NULL,
	[Address] NVARCHAR(100) NOT NULL,
	Phone [dbo].[phone] NOT NULL,
	ContactName NVARCHAR(40) NOT NULL
)
GO

CREATE TABLE Job(
	IdJob INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	NameJob NVARCHAR(30) NOT NULL,
	Salary DECIMAL(10,2) NOT NULL
)
GO

CREATE TABLE Discount(
	IdDiscount INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	NameDiscount NVARCHAR(100) NOT NULL,
	[Percent] DECIMAL(3,1) NOT NULL
)
GO

CREATE TABLE Employee(
	IdEmployee INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FirstName NVARCHAR(100) NOT NULL,
	LastName NVARCHAR(100) NOT NULL,
	MidName NVARCHAR(100),
	IdJob INT FOREIGN KEY REFERENCES Job(IdJob) NOT NULL,
	Phone [dbo].[phone],
	HireDate DATE DEFAULT (getdate()),
	Gender CHAR(1) NOT NULL,
	Seniority INT DEFAULT (0)
)
GO

CREATE TABLE Store(
	IdPosition INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	IdProduct INT FOREIGN KEY REFERENCES Product(IdProduct) NOT NULL,
	Qty INT DEFAULT (0),
	LastArrDate DATETIME
)
GO

CREATE TABLE Bonus(
	CardNum CHAR(12) PRIMARY KEY NOT NULL,
	QtyBonus INT DEFAULT (0),
	IdDiscount INT FOREIGN KEY REFERENCES Discount(IdDiscount)
)
GO

CREATE TABLE Supply(
	IdSupp INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	IdProvider INT FOREIGN KEY REFERENCES Provider(IdProvider) NOT NULL,
	[Date] DATETIME DEFAULT(getdate()),
	Employee INT FOREIGN KEY REFERENCES Employee(IdEmployee)
)
GO

CREATE TABLE SuppItem(
	IdSupp INT FOREIGN KEY REFERENCES Supply(IdSupp) NOT NULL,
	IdProduct INT FOREIGN KEY REFERENCES Product(IdProduct) NOT NULL,
	Qty INT,
	PRIMARY KEY (Idsupp, IdProduct)
)
GO

CREATE TABLE [Shift](
	IdShift INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	IdEmployee1 INT FOREIGN KEY REFERENCES Employee(IdEmployee) NOT NULL,
	IdEmployee2 INT FOREIGN KEY REFERENCES Employee(IdEmployee) NOT NULL,
	DateShift DATE DEFAULT (getdate())
)
GO

CREATE TABLE Sale(
	IdSale INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	IdProduct INT FOREIGN KEY REFERENCES Product(IdProduct) NOT NULL,
	Qty INT NOT NULL,
	DateSale DATETIME DEFAULT(getdate()),
	SalePrice DECIMAL(10,2) NOT NULL,
	CardNum CHAR(12) FOREIGN KEY REFERENCES Bonus(CardNum),
	IdShift INT FOREIGN KEY REFERENCES [Shift](IdShift) NOT NULL,
	ResultPrice DECIMAL (10,2) NULL
)
GO
