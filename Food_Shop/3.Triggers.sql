/**
	INSERTING TEST VALUES INTO DB

	DBCC CHECKIDENT(%TableName%,RESEED,0)

	CHANGELOG

	--ALTER SaleCK
	--MOVED CHECKS AND COLUMNS TO RESPONDING FILES
	--ADDED TRIGGER TO CHECK JOB ON SHIFT(ALTER TABLE TOO)
**/

	--Product
INSERT INTO Product
	VALUES ('Greecha',250,0)
INSERT INTO Product
	VALUES ('Rise',150,0)
INSERT INTO Product
	VALUES ('Resistance',20.5,0)
INSERT INTO Product
	VALUES ('PshPsheno',89.9,0)
INSERT INTO Product
	VALUES ('ManCo',45.8,0)
INSERT INTO Product
	VALUES ('MagaRonin',7889,0)
INSERT INTO Product
	VALUES ('Scukor',45.6,0)
INSERT INTO Product
	VALUES ('Sila',546.32,0)
INSERT INTO Product
	VALUES ('Semka',654,0)
INSERT INTO Product
	VALUES ('Chleb',36,0)
GO


	--Job
INSERT INTO Job
	VALUES ('Director',55000,0)
INSERT INTO Job
	VALUES ('Cashier',30000,0)
INSERT INTO Job
	VALUES ('Storageman',35000,0)
INSERT INTO Job
	VALUES ('InternCashier',20000,0)
INSERT INTO Job
	VALUES ('InternStorageman',23000,0)
GO


	--Store
INSERT INTO [Store]
	VALUES (1,0,getdate(),0)
INSERT INTO [Store]
	VALUES (2,0,getdate(),0)
INSERT INTO [Store]
	VALUES (3,0,getdate(),0)
INSERT INTO [Store]
	VALUES (4,0,getdate(),0)
INSERT INTO [Store]
	VALUES (5,0,getdate(),0)
INSERT INTO [Store]
	VALUES (6,0,getdate(),0)
INSERT INTO [Store]
	VALUES (7,0,getdate(),0)
INSERT INTO [Store]
	VALUES (8,0,getdate(),0)
INSERT INTO [Store]
	VALUES (9,0,getdate(),0)
INSERT INTO [Store]
	VALUES (10,0,getdate(),0)
GO


	--Employee
INSERT INTO Employee
	VALUES ('Lomaev','Alexei','Valera',2,'+7(564)6544521',getdate(),'M',0)
INSERT INTO Employee
	VALUES ('Kondarat','Lion','Valerich',3,'+7(564)6544421',getdate(),'M',0)
INSERT INTO Employee
	VALUES ('Lomayov','Alexios',NULL,3,'+7(564)6545521',getdate(),'F',0)
INSERT INTO Employee
	VALUES ('Dyudyukin','Alexandr','Isgos',2,'+7(213)6542333',getdate(),'F',0)
GO


	--Provider
INSERT INTO [Provider]
	VALUES ('LOMAESHKA','Pushkina,Kolotushkina,9','+7(123)7898478','Lololoshka',0)
INSERT INTO [Provider]
	VALUES ('OOO "OBORONA"','Privat, Andrey, 123/2','+7(136)7878235','PinkGuy',0)
INSERT INTO [Provider]
	VALUES ('SBERPUNK','Earth, Russia, Undefined','+7(983)9844651','Joseph Stalin',0)
INSERT INTO [Provider]
	VALUES ('PinGUI','Linux, SomeNameThatEndsOnTU, 1','+7(243)1326475','FuPolina',0)
INSERT INTO [Provider]
	VALUES ('SQLife','KS54, kab 101, ugol','+7(472)7919148','OPSenpai',0)
GO


	--Supply
--HAVE A TRIGGER INSERT BY ONE
INSERT INTO Supply
	VALUES (4, '2020-20-02 16:30:00', 2,0)
INSERT INTO Supply
	VALUES (4, '2020-17-02', 3,0)
INSERT INTO Supply
	VALUES (2, getdate(), 2,0)
INSERT INTO Supply
	VALUES (2, getdate(), 3,0)
GO


	--SuppItem
--HAVE A TRIGGER INSERT BY ONE
INSERT INTO SuppItem
	VALUES (2,1,351,0)
INSERT INTO SuppItem
	VALUES (3,3,2475,0)
INSERT INTO SuppItem
	VALUES (7,4,476,0)
INSERT INTO SuppItem
	VALUES (4,5,15,0)
INSERT INTO SuppItem
	VALUES (5,8,45,0)
INSERT INTO SuppItem
	VALUES (6,9,97,0)
INSERT INTO SuppItem
	VALUES (7,10,644,0)
INSERT INTO SuppItem
	VALUES (6,6,987,0)
GO


	--Shift
--HAVE A TRIGGER INSERT BY ONE
INSERT INTO [Shift]
	VALUES (1,3,'12-02-2020',0)
INSERT INTO [Shift]
	VALUES (4,2,getdate(),0)
INSERT INTO [Shift]
	VALUES (1,2,'14-02-2020',0)
INSERT INTO [Shift]
	VALUES (4,3,'17-02-2020',0)
GO


	--Discount
INSERT INTO Discount
	VALUES ('Wood',5,0)--1000
INSERT INTO Discount
	VALUES ('Bronze',7.5,0)--2000
INSERT INTO Discount
	VALUES 		('Silver',12,0)--3500
INSERT INTO Discount
	VALUES ('Gold',15,0)--5000
INSERT INTO Discount
	VALUES ('Platinum',17.5,0)--6000
INSERT INTO Discount
	VALUES 	('Titan',20,0)--7500
INSERT INTO Discount
	VALUES ('Diamond',24.5,0)--99999999
INSERT INTO Discount
	VALUES ('BOSS',99.9,0)-- -1
GO


	--Bonus
INSERT INTO Bonus
	VALUES ('123456789101',12,1,0)
INSERT INTO Bonus
	VALUES ('753951852456',200,2,0)
INSERT INTO Bonus
	VALUES ('133713371337',1000,3,0)
INSERT INTO Bonus
	VALUES ('234882135924',10,1,0)
INSERT INTO Bonus
	VALUES ('741852963145',1,1,0)
GO


	--Sale
--HAVE A TRIGGER INSERT BY ONEALTER TABLE Sale
INSERT INTO Sale
	VALUES (5,2,NULL,142,NULL,3,NULL,0)
INSERT INTO Sale
	VALUES (2,6,NULL,2563,'123456789101',5,NULL,0)
INSERT INTO Sale
	VALUES (4,3,NULL,432,NULL,6,NULL,0)
INSERT INTO Sale
	VALUES (6,34,getdate(),65799,'741852963145',4,NULL,0)
INSERT INTO Sale
	VALUES (2,47,getdate(),24375,'234882135924',7,NULL,0)
INSERT INTO Sale
	VALUES (9,24,getdate(),1518,NULL,4,NULL,0)
INSERT INTO Sale
	VALUES (10,1,getdate(),61,'741852963145',8,NULL,0)
INSERT INTO Sale
	VALUES (6,5,getdate(),1,'741852963145',7,2,0)
GO




/**
		CREATING TRIGGERS
**/

CREATE OR ALTER TRIGGER ArrDate 
	ON SuppItem AFTER INSERT
AS
	DECLARE @D DATETIME, @I INT, @Q INT
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT @I = (SELECT i.IdProduct FROM inserted i)
	SELECT @D = (SELECT MAX(s.[Date]) FROM SuppItem si JOIN Supply s ON (si.IdSupp = s.IdSupp) WHERE si.IdProduct = @I)
	SELECT @Q = (SELECT i.Qty FROM inserted i)

	UPDATE Store
	SET LastArrDate = @D, Qty = Qty+@Q
	WHERE IdProduct = @I

	PRINT ('Supply is Stored (Update complete)')
END
GO


CREATE OR ALTER TRIGGER SaleCK
	ON Sale AFTER INSERT
AS
	DECLARE @Disc DECIMAL(5,3), @B CHAR(12), @SP DECIMAL(10,2), @BP DECIMAL(10,2), @Q INT, @I INT, @S INT, @D DATE, @SH INT, @BQ INT
BEGIN
	SET NOCOUNT ON;

	SELECT @S = (SELECT i.IdSale FROM inserted i)
	SELECT @I = (SELECT i.IdProduct FROM inserted i)
	SELECT @Q = (SELECT i.Qty FROM inserted i)
	SELECT @SH = (SELECT i.IdShift FROM inserted i)
	SELECT @BP = (SELECT BuyPrice FROM Product WHERE IdProduct = @I)
	SELECT @SP = (SELECT @BP*2*@Q)
	SELECT @B = (SELECT i.CardNum FROM inserted i)
	SELECT @Disc = (SELECT d.[Percent]/100 FROM Discount d JOIN Bonus b ON (d.IdDiscount = b.IdDiscount) WHERE b.CardNum = @B)
	SELECT @D = (SELECT DateShift FROM Shift WHERE IdShift = @SH)
	
	IF (@SP < @BP)
		BEGIN
			PRINT ('!!You trying to sale cheeper that you can!')
			ROLLBACK TRANSACTION
		END
	ELSE
		IF ((SELECT Qty FROM Store WHERE IdProduct = @I) < @Q)
			BEGIN
				PRINT ('!You cant sale more product that we have!!!')
				ROLLBACK TRANSACTION
			END
		ELSE
			BEGIN

				UPDATE Store
				SET Qty = Qty - @Q
				WHERE IdProduct = @I

				UPDATE Sale
				SET DateSale = @D, SalePrice = @SP
				WHERE IdSale = @S

				IF (@B IS NOT NULL)
					BEGIN
						UPDATE Sale
						SET ResultPrice = SalePrice - (SalePrice * @Disc)
						WHERE IdSale = @S

						SELECT @BQ = CAST((SELECT ResultPrice/10 FROM Sale WHERE IdSale = @S) AS INT)

						UPDATE Bonus
						SET QtyBonus = QtyBonus + @BQ
						WHERE CardNum = @B

						PRINT('We add discount and bonuses for you, have a nice day')
					END
				ELSE
					BEGIN
						PRINT ('Maybe you want to get our Bonus Card? Its free')
						
						UPDATE Sale
						SET ResultPrice = SalePrice
						WHERE IdSale = @S
					END
			END
END	
GO



CREATE OR ALTER TRIGGER StockAlert
	ON Store AFTER UPDATE
AS
BEGIN
	IF ((SELECT Qty FROM inserted) < 15)
		PRINT ('Warning! This Product is almost sold!')
END
GO


CREATE OR ALTER TRIGGER ShiftWorks
		ON dbo.[Shift] AFTER INSERT
AS
	DECLARE @C INT, @S INT, @J1 INT, @J2 INT
BEGIN
	SET NOCOUNT ON;

	SELECT @C = (SELECT i.Cashier from inserted i)
	SELECT @S = (SELECT i.Storager from inserted i)
	SELECT @J1 = (SELECT e.IdJob FROM Employee e WHERE @C = e.IdEmployee)
	SELECT @J2 = (SELECT e.IdJob FROM Employee e WHERE @S = e.IdEmployee)

	IF(@J1 != 2 OR @J2 != 3)
		BEGIN
			PRINT('You made mistake with employee')
			PRINT(@C)
			PRINT(@S)
			PRINT(@J1)
			PRINT(@J2)
			ROLLBACK TRANSACTION
		END
END
GO


CREATE OR ALTER TRIGGER BonusAdd
		ON Bonus AFTER UPDATE
AS
	DECLARE @Q INT, @B NVARCHAR(12)
BEGIN
	SET NOCOUNT ON

	SELECT @B = (SELECT i.CardNum FROM inserted i)
	SELECT @Q = (SELECT QtyBonus FROM Bonus WHERE CardNum = @B)

	IF (@Q>7500)
		BEGIN
			UPDATE Bonus
			SET IdDiscount = 7
			WHERE CardNum = @B
			
			PRINT('Cogratulations! You have maxed up your level - Diamond')
		END
	ELSE IF (@Q>6000)
		BEGIN
			UPDATE Bonus
			SET IdDiscount = 6
			WHERE CardNum = @B

			PRINT('Wow, look at this. Now you have a Titan card')
		END
	ELSE IF (@Q>5000)
		BEGIN
			UPDATE Bonus
			SET IdDiscount = 5
			WHERE CardNum = @B

			PRINT('Oh, you have entered new level - Platinum')
		END
	ELSE IF (@Q>3500)
		BEGIN
			UPDATE Bonus
			SET IdDiscount = 4
			WHERE CardNum = @B

			PRINT('Are you Midas? Because you get Gold level')
		END
	ELSE IF (@Q>2000)
		BEGIN
			UPDATE Bonus
			SET IdDiscount = 3
			WHERE CardNum = @B

			PRINT('So, Sir... Si.. Silver!!!')
		END
	ELSE IF (@Q>1000)
		BEGIN
			UPDATE Bonus
			SET IdDiscount = 2
			WHERE CardNum = @B

			PRINT('Great, now you are Bronze!')
		END
END
GO


CREATE OR ALTER TRIGGER SuppCheck
	ON Supply AFTER INSERT
AS
	DECLARE @E INT, @J INT
BEGIN
	
	SELECT @E = (SELECT i.Employee FROM inserted i)
	SELECT @J = (SELECT IdJob FROM Employee WHERE IdEmployee = @E)

	IF (@J NOT IN (SELECT IdJob FROM Job WHERE NameJob IN ('Storager')))
		BEGIN
			PRINT('This employee doesnt have the permission to do this')
			ROLLBACK TRANSACTION
		END
END
GO