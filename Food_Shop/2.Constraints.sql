USE SampleDB
GO

/**
	Script to add all constraints

	If Id is broke, Here is your pray:
	DBCC CHECKIDENT(%TableName%,RESEED,0)

	CHANGELOG
	
	--MOVED ALTER COLUMNS AND TYPE TO CREATE TABLE
	--FIX SOME CHECKS AND STANDATISE IT
	--MOVED CHECKS FROM FOREIGN FILE
**/

--Employee
ALTER TABLE [dbo].[Employee]
	ADD CONSTRAINT CK_Phone
		CHECK (Phone LIKE '+7([0-9][0-9][0-9])[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO
ALTER TABLE Employee
	ADD CONSTRAINT CK_Hire
		CHECK(HireDate <= getdate())
GO
ALTER TABLE Employee
	ADD CONSTRAINT CK_Fname
		CHECK (FirstName NOT LIKE '%[^a-z]%')
GO
ALTER TABLE Employee
	ADD CONSTRAINT CK_Lname
		CHECK (LastName NOT LIKE '%[^a-z-]%')
GO
ALTER TABLE Employee
	ADD CONSTRAINT CK_Mname
		CHECK (MidName NOT LIKE '%[^a-z]%')
GO
ALTER TABLE Employee
	ADD CONSTRAINT CK_Gender
		CHECK(Gender LIKE '[MF]')
GO

--Provider
ALTER TABLE [dbo].[Provider]
	ADD CONSTRAINT CK_Phone1
		CHECK (Phone LIKE '+7([0-9][0-9][0-9])[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO
ALTER TABLE [Provider]
	DROP CONSTRAINT CK_NameProv
GO
ALTER TABLE [Provider]
	DROP CONSTRAINT CK_Addr
GO
ALTER TABLE [Provider]
	DROP CONSTRAINT CK_Contact
GO
ALTER TABLE [Provider]
	ADD CONSTRAINT CK_NameProv
		CHECK(NameProv NOT LIKE '%[^a-zA-Z0-9 "]%')
GO
ALTER TABLE [Provider]
	ADD CONSTRAINT CK_Addr
		CHECK([Address] NOT LIKE '%[^a-zA-Z0-9 ,/.-]%')
GO
ALTER TABLE [Provider]
	ADD CONSTRAINT CK_Contact
		CHECK(ContactName NOT LIKE '%[^a-zA-Z ]%')
GO

--Product
ALTER TABLE Product
	ADD CONSTRAINT CK_Desc
		CHECK (Description NOT LIKE '%[^a-z0-9 -/]%')
GO
ALTER TABLE Product
	ADD CONSTRAINT CK_Price
		CHECK(BuyPrice > 0)
GO

--Job
ALTER TABLE Job
	ADD CONSTRAINT CK_Name
		CHECK (NameJob NOT LIKE '%[^a-z0-9-]%')
GO
ALTER TABLE Job
	ADD CONSTRAINT CK_Salary
		CHECK(Salary > 0)
GO

--Shift
ALTER TABLE [Shift]
	ADD CONSTRAINT CK_Empl
		CHECK(IdEmployee1 <> IdEmployee2)
GO
ALTER TABLE [Shift]
	ADD CONSTRAINT CK_Date
		CHECK(DateShift <= getdate())
GO

--Store
ALTER TABLE [Store]
	ADD CONSTRAINT CK_Qty
		CHECK (Qty >= 0)
GO

--Supply
ALTER TABLE [Supply]
	ADD CONSTRAINT CK_DateSupp
		CHECK([Date] <= getdate())
GO

--SuppItem
ALTER TABLE SuppItem
	ADD CONSTRAINT CK_QtyItem
		CHECK (Qty > 0)
GO

--Discount
ALTER TABLE Discount
	ADD CONSTRAINT CK_Disc
		CHECK([Percent] > 0)
GO
ALTER TABLE Discount
	ADD CONSTRAINT CK_NameDisc
		CHECK (NameDiscount NOT LIKE '%[^a-z0-9 -]%')
GO

--Bonus
ALTER TABLE Bonus
	ADD CONSTRAINT CK_Bonus
		CHECK(QtyBonus >= 0)
GO
ALTER TABLE Bonus
	ADD CONSTRAINT CK_Card
		CHECK (CardNum LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

--Sale
ALTER TABLE Sale
	ADD CONSTRAINT CK_QtySale
		CHECK(Qty > 0)
GO
ALTER TABLE Sale
	ADD CONSTRAINT CK_DateSale
		CHECK(DateSale <= getdate())
GO
ALTER TABLE Sale
	ADD CONSTRAINT CK_PriceSale
		CHECK(SalePrice > 0)
GO
