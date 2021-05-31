USE DB_Dentist
GO

/*
Triggers to handle all DML in DB
*/
-- CK Triggers checking values and rollback if something is wrong. Also made out of interest to have without blanks
CREATE OR ALTER TRIGGER CK_SuppMed -- Change table name
	ON SuppMed FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@Q INT -- Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	
	WHILE (@I < @C)
	BEGIN
		SELECT @Q = (SELECT i.Qty FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		-- Select all vars to check (v + ^)
		IF (@Q > 0)
		BEGIN
			PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
		END
		SET @I = @I + 1
	END
END
GO

CREATE OR ALTER TRIGGER CK_Supply -- Change table name
	ON Supply FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@D DATETIME --Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	SET @IdentityValue = (SELECT COUNT(*) FROM Client) - @C
	
	WHILE (@I < @C)
	BEGIN
		SELECT @D = (SELECT i.DateSupp FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		--Select all vars to check (v + ^)
		IF (@D <= GETDATE())
		BEGIN
			PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
			DBCC CHECKIDENT ('Supply', RESEED, @IdentityValue)
		END
		SET @I = @I + 1
	END
END
GO

CREATE OR ALTER TRIGGER CK_Store -- Change table name
	ON Store FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@Q INT, @LA DATETIME --Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	SET @IdentityValue = (SELECT COUNT(*) FROM Client) - @C
	
	WHILE (@I < @C)
	BEGIN
		SELECT @Q = (SELECT i.Qty FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @LA = (SELECT i.LastArr FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		--Select all vars to check (v + ^)
		IF (@Q > 0) AND 
			(@LA <= GETDATE())
		BEGIN
			PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
			DBCC CHECKIDENT ('Store', RESEED, @IdentityValue)
		END
		SET @I = @I + 1
	END
END
GO

CREATE OR ALTER TRIGGER CK_Shift -- Change table name
	ON [Shift] FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@S DATETIME, @E DATETIME --Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	SET @IdentityValue = (SELECT COUNT(*) FROM Client) - @C
	
	WHILE (@I < @C)
	BEGIN
		SELECT @S = (SELECT i.StartTime FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @E = (SELECT i.EndTime FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		--Select all vars to check (v + ^)
		IF (@S <= GETDATE()) AND 
			((@E IS NULL) OR (@E > @S))
		BEGIN
			PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
			DBCC CHECKIDENT ('Shift', RESEED, @IdentityValue)
		END
		SET @I = @I + 1
	END
END
GO

CREATE OR ALTER TRIGGER CK_Reception -- Change table name
	ON [Reception] FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@T DATETIME --Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	SET @IdentityValue = (SELECT COUNT(*) FROM Client) - @C
	
	WHILE (@I < @C)
	BEGIN
		SELECT @T = (SELECT i.TimeSession FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		--Select all vars to check (v + ^)
		IF (@T <= GETDATE())
		BEGIN
			PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
			DBCC CHECKIDENT ('Reception', RESEED, @IdentityValue)
		END
		SET @I = @I + 1
	END
END
GO

CREATE OR ALTER TRIGGER CK_Provider -- Change table name
	ON [Provider] FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@N NVARCHAR(25), @P NVARCHAR(14), @E NVARCHAR(25) --Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	SET @IdentityValue = (SELECT COUNT(*) FROM Client) - @C
	
	WHILE (@I < @C)
	BEGIN
		SELECT @N = (SELECT i.NameProv FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @P = (SELECT i.Phone FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @E = (SELECT i.Email FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		--Select all vars to check (v + ^)
		IF (@N NOT LIKE '[^A-ZÀ-ß]%[^a-zà-ÿ 0-9-]%') AND
			(@P IS NOT NULL OR @E IS NOT NULL)
		BEGIN
			IF (@P LIKE '+7(9[0-9][0-9])[0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR @P IS NULL) AND 
				(@E NOT LIKE '%[^a-zA-Z0-9_]%[^@]%[^a-z]%[^.]%[^a-z]%' OR @E IS NULL)
				
				PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
			DBCC CHECKIDENT ('Provider', RESEED, @IdentityValue)
		END
		SET @I = @I + 1
	END
END
GO

CREATE OR ALTER TRIGGER CK_PriceList -- Change table name
	ON PriceList FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@N NVARCHAR(25), @P DECIMAL(7,2) --Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	SET @IdentityValue = (SELECT COUNT(*) FROM Client) - @C
	
	WHILE (@I < @C)
	BEGIN
		SELECT @N = (SELECT i.NameService FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @P = (SELECT i.PriceService FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		--Select all vars to check (v + ^)
		IF (@N NOT LIKE '[^A-ZÀ-ß]%[^a-zà-ÿ 0-9(),.-]%') AND 
			(@P > 0)
		BEGIN
			PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
			DBCC CHECKIDENT ('PriceList', RESEED, @IdentityValue)
		END
		SET @I = @I + 1
	END
END
GO

CREATE OR ALTER TRIGGER CK_Medicaments -- Change table name
	ON Medicaments FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@N NVARCHAR(40), @P DECIMAL(8,2) --Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	SET @IdentityValue = (SELECT COUNT(*) FROM Client) - @C
	
	WHILE (@I < @C)
	BEGIN
		SELECT @N = (SELECT i.NameMed FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @P = (SELECT i.Price FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		--Select all vars to check (v + ^)
		IF (@N NOT LIKE '[^A-ZÀ-ß]%[^a-zà-ÿ 0-9-]%') AND 
			(@P > 0)
		BEGIN
			PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
			DBCC CHECKIDENT ('Medicaments', RESEED, @IdentityValue)
		END
		SET @I = @I + 1
	END
END
GO

CREATE OR ALTER TRIGGER CK_Job -- Change table name
	ON Job FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@N NVARCHAR(25) --Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	SET @IdentityValue = (SELECT COUNT(*) FROM Client) - @C
	
	WHILE (@I < @C)
	BEGIN
		SELECT @N = (SELECT i.NameJob FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		--Select all vars to check (v + ^)
		IF (@N NOT LIKE '[^A-ZÀ-ß]%[^a-zà-ÿ 0-9-]%')
		BEGIN
			PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
			DBCC CHECKIDENT ('Job', RESEED, @IdentityValue)
		END
		SET @I = @I + 1
	END
END
GO

CREATE OR ALTER TRIGGER CK_Employee -- Change table name
	ON Employee FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@F NVARCHAR(25), @L NVARCHAR(25), @M NVARCHAR(25), @G CHAR(1), @S DECIMAL(8,2), @P NVARCHAR(14), @HD DATETIME --Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	SET @IdentityValue = (SELECT COUNT(*) FROM Client) - @C
	
	WHILE (@I < @C)
	BEGIN
		SELECT @F = (SELECT i.FirstName FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @L = (SELECT i.LastName FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @M = (SELECT i.MidName FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @G = (SELECT i.Gender FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @S = (SELECT i.Salary FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @P = (SELECT i.Phone FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @HD = (SELECT i.HireDate FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		--Select all vars to check (v + ^)
		IF (@F NOT LIKE '[^A-ZÀ-ß]%[^a-zà-ÿ]%') AND 
			(@L NOT LIKE '[^A-ZÀ-ß]%[^a-zà-ÿ-]%') AND 
			(@M NOT LIKE '[^A-ZÀ-ß]%[^a-zà-ÿ ]%') AND 
			(@G NOT LIKE '%[^MF]%') AND 
			(@S > 0) AND
			(@P LIKE '+7(9[0-9][0-9])[0-9][0-9][0-9][0-9][0-9][0-9][0-9]') AND 
			(@HD <= GETDATE())
		BEGIN
			PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
			DBCC CHECKIDENT ('Employee', RESEED, @IdentityValue)
		END
		SET @I = @I + 1
	END
END
GO

CREATE OR ALTER TRIGGER CK_Discount -- Change table name
	ON Discount FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@N NVARCHAR(25), @P DECIMAL(4,2) --Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	SET @IdentityValue = (SELECT COUNT(*) FROM Client) - @C
	
	WHILE (@I < @C)
	BEGIN
		SELECT @N = (SELECT i.NameDiscount FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @P = (SELECT i.PercentDiscount FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		--Select all vars to check (v + ^)
		IF (@N NOT LIKE '[^A-ZÀ-ß]%[^a-zà-ÿ0-9 .-]%') AND 
			(@P > 0)
		BEGIN
			PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
			DBCC CHECKIDENT ('Discount', RESEED, @IdentityValue)
		END
		SET @I = @I + 1
	END
END
GO

CREATE OR ALTER TRIGGER CK_Client -- Change table name
	ON Client FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@F NVARCHAR(25), @L NVARCHAR(25), @M NVARCHAR(25), @P NVARCHAR(14), @G CHAR(1), @S NVARCHAR(25) --Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	SET @IdentityValue = (SELECT COUNT(*) FROM Client) - @C
	
	WHILE (@I < @C)
	BEGIN
		SELECT @F = (SELECT i.FirstName FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @L = (SELECT i.LastName FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @M = (SELECT i.MidName FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @P = (SELECT i.Phone FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @G = (SELECT i.Gender FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		SELECT @S = (SELECT i.Subscribe FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		--Select all vars to check (v + ^)
		IF (@F NOT LIKE '[^A-ZÀ-ß]%[^a-zà-ÿ]%') AND 
			(@L NOT LIKE '[^A-ZÀ-ß]%[^a-zà-ÿ-]%') AND 
			(@M NOT LIKE '[^A-ZÀ-ß]%[^a-zà-ÿ ]%' OR @M IS NULL) AND 
			(@P LIKE '+7(9[0-9][0-9])[0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR @P IS NULL) AND 
			(@G NOT LIKE '%[^MF]%') AND 
			(@S NOT LIKE '%[^a-zA-Z0-9_]%[^@]%[^a-z]%[^.]%[^a-z]%' OR @S IS NULL)
		BEGIN
			PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
			DBCC CHECKIDENT ('Client', RESEED, @IdentityValue)
		END
		SET @I = @I + 1
	END
END
GO

CREATE OR ALTER TRIGGER CK_Citizenship -- Change table name
	ON Citizenship FOR INSERT
AS
	DECLARE @I INT, @C INT, @IdentityValue BIGINT, 
		@N NVARCHAR(25) --Add vars to check
BEGIN
	SET NOCOUNT ON
	SET @I = 0
	SELECT @C = (SELECT COUNT(*) FROM inserted)
	SET @IdentityValue = (SELECT COUNT(*) FROM Client) - @C
	
	WHILE (@I < @C)
	BEGIN
		SELECT @N = (SELECT i.NameCitizenship FROM inserted i ORDER BY (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE ORDINAL_POSITION = 1 AND TABLE_NAME = 'Client') OFFSET @I ROWS FETCH NEXT 1 ROWS ONLY)
		--Select all vars to check (v + ^)
		IF (@N NOT LIKE '[^A-ZÀ-ß]%[^a-zà-ÿ -]%')
		BEGIN
			PRINT('ok')
		END
		ELSE 
		BEGIN
			PRINT('ERROR ON ' + CAST(@I+1 AS NVARCHAR) + ' VALUE!')
			ROLLBACK TRANSACTION
			DBCC CHECKIDENT ('Citizenship', RESEED, @IdentityValue)
		END
		SET @I = @I + 1
	END
END
GO

-- Trigger that updates store status every operation
CREATE OR ALTER TRIGGER SP_ServMed
	ON ServMed FOR INSERT
AS
	DECLARE @I INT, @Q INT
BEGIN
	SET NOCOUNT ON

	SELECT @I = (SELECT IdMedicament FROM inserted)
	SELECT @Q = (SELECT Qty FROM inserted)

	UPDATE Store
	SET Qty = Qty - @Q
	WHERE IdMed = @I

	PRINT('success')
END
GO

-- Trigger that updates store status every supply
CREATE OR ALTER TRIGGER SP_SuppMed
	ON SuppMed FOR INSERT
AS
	DECLARE @I INT, @Q INT
BEGIN
	SELECT @I = (SELECT IdMed FROM inserted)
	SELECT @Q = (SELECT Qty FROM inserted)

	UPDATE Store
	SET Qty = Qty + @Q
	WHERE IdMed = @I

	PRINT ('Supply added successfully')
END
GO

-- Trigge for adding bonuses
CREATE OR ALTER TRIGGER BN_Receprtion
	ON Reception FOR INSERT
AS
	DECLARE @S INT, @P DECIMAL(7,2), @B INT, @CD VARCHAR(12), @C INT
BEGIN
	SELECT @C = (SELECT IdClient FROM inserted)
	SELECT @CD = (SELECT CardNum FROM Client)
	SELECT @S = (SELECT IdService FROM inserted)
	SELECT @P = (SELECT PriceService FROM PriceList WHERE IdService = @S)
	SET @B = @P / 100

	UPDATE BonusCard
	SET QtyBonus = QtyBonus + @B
	WHERE CardNum = @CD

	PRINT('Bonus added successfully')
END
GO

-- Trigger to lvlup discount rank
CREATE OR ALTER TRIGGER BN_BonusCard
	ON BonusCard AFTER INSERT, UPDATE
AS
	DECLARE @C VARCHAR(12), @DO INT, @Q INT, @T DECIMAL(4,0), @DN INT
BEGIN
	SELECT @C = (SELECT CardNum FROM inserted)
	SELECT @DO = (SELECT IdDiscount FROM inserted)
	SELECT @Q = (SELECT QtyBonus FROM inserted)
	SELECT @T = (SELECT MAX(ThresholdBonus) FROM Discount WHERE ThresholdBonus <= @Q)
	SELECT @DN = (SELECT IdDiscount FROM Discount WHERE ThresholdBonus = @T)
	
	IF (@DO <> @DN)
	BEGIN
		ALTER TABLE BonusCard DISABLE TRIGGER BN_BonusCard

		UPDATE BonusCard
		SET IdDiscount = @DN
		WHERE CardNum = @C

		ALTER TABLE BonusCard ENABLE TRIGGER BN_BonusCard

		PRINT('Congratulations, You have new discount rank!')
	END
END
GO