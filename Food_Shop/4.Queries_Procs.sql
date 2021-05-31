USE DBSample
GO

/**
	CREATING QUERIES
	
	DBCC CHECKIDENT(%TableName%,RESEED,0)

**/

	--Employee List
SELECT CASE WHEN e.MidName IS NULL
			THEN e.FirstName+' '+e.LastName
			ELSE e.FirstName+' '+e.LastName+' '+e.MidName
			END AS 'FIO', 
			j.NameJob AS 'Job', 
			e.Seniority AS 'Seniority',
			COUNT(sh.IdShift) AS 'Shifts'
FROM Employee e JOIN 
		Job j ON (e.IdJob = j.IdJob) JOIN 
		[Shift] sh ON (e.IdEmployee = sh.Cashier OR e.IdEmployee = sh.Storager)
GROUP BY CASE WHEN e.MidName IS NULL
			THEN e.FirstName+' '+e.LastName
			ELSE e.FirstName+' '+e.LastName+' '+e.MidName
			END, 
			j.NameJob, 
			e.Seniority
GO

	--Supply List (In comment condition 1 month)
SELECT s.IdSupp AS 'Supply Number',
		p.Description AS 'Product',
		s.Date AS 'Arrived',
		si.Qty AS 'Quantity',
		CASE WHEN e.MidName IS NULL
			THEN e.FirstName+' '+e.LastName
			ELSE e.FirstName+' '+e.LastName+' '+e.MidName
			END AS 'Applier',
		pr.NameProv AS 'Provided by'
FROM Supply s JOIN SuppItem si ON (s.IdSupp = si.IdSupp) 
				JOIN Product p ON (si.IdProduct = p.IdProduct) 
				JOIN Provider pr ON (s.IdProvider = pr.IdProvider) 
				JOIN Employee e ON (s.Employee = e.IdEmployee)
--WHERE month(s.Date) = month(GETDATE())-1 AND year(s.Date) = year(getdate())
GO

	--Most Profit Products List
SELECT p.Description, 
		SUM(s.Qty) AS 'Quantity', 
		SUM(s.SalePrice) AS 'Money', 
		SUM(s.SalePrice)/SUM(s.Qty) AS 'Money per Unit'
FROM Sale s JOIN 
		Product p ON (s.IdProduct = p.IdProduct)
WHERE s.IsDeleted = 0 AND p.IsDeleted = 0
GROUP BY p.Description
ORDER BY SUM(s.SalePrice)/SUM(s.Qty) DESC
GO

	--Less Profit Products
SELECT p.Description, 
		SUM(s.Qty) AS 'Quantity', 
		SUM(s.SalePrice) AS 'Money', 
		SUM(s.SalePrice)/SUM(s.Qty) AS 'Money per Unit'
FROM Sale s JOIN 
		Product p ON (s.IdProduct = p.IdProduct)
WHERE s.IsDeleted = 0 AND p.IsDeleted = 0
GROUP BY p.Description
ORDER BY SUM(s.SalePrice)/SUM(s.Qty)
GO



	--Most Profit pair of Workers
SELECT sh.Cashier, 
		sh.Storager, 
		SUM(s.SalePrice) AS 'Sales', 
		SUM(s.Qty) AS 'Quantity of Products', 
		SUM(s.SalePrice)/SUM(s.Qty) AS 'Money per Unit'
FROM Sale s JOIN 
		Shift sh ON (s.IdShift = sh.IdShift)
WHERE sh.IsDeleted = 0 AND s.IsDeleted = 0
GROUP BY Cashier,Storager
ORDER BY SUM(s.SalePrice)/SUM(s.Qty) DESC, sh.Cashier, sh.Storager 
GO


	--Card Info
SELECT b.CardNum AS 'Card Number',
		b.QtyBonus AS 'Bonus Quantity',
		(d.Points - b.QtyBonus) AS 'Bonuses Needed',
		d.NameDiscount AS 'Discount Type',
		d.[Percent] AS 'Discount'
FROM Bonus b JOIN 
	Discount d ON (b.IdDiscount = d.IdDiscount)
WHERE (d.Points - b.QtyBonus) > 0
GO

	--Most Buyed Products by Card
SELECT s.CardNum AS 'Card', 
		p.Description AS 'Product', 
		COUNT(s.CardNum) AS 'Times Buyed'
FROM Sale s JOIN 
		Product p ON (s.IdProduct = p.IdProduct) JOIN 
		Bonus b ON (s.CardNum = b.CardNum)
WHERE s.CardNum IS NOT NULL AND b.IdDiscount != 1337420228
GROUP BY s.CardNum, p.Description
ORDER BY COUNT(s.CardNum) DESC, s.CardNum
GO

/**
		NOW IS CLOSE ALPHA TEST CODE
**/




ALTER PROC productInfo
	@P NVARCHAR(100) NULL
AS
	IF (@P IS NOT NULL)
		BEGIN
			SELECT @P AS 'Product', 
					p.BuyPrice AS 'Buy price', 
					st.Qty AS 'Quantity on store', 
					(p.BuyPrice*2) AS 'Sale Price', 
					SUM(s.ResultPrice) AS 'Sold for'
			FROM Product p JOIN 
					Sale s ON (p.IdProduct = s.IdProduct) JOIN 
					Store st ON (st.IdProduct = p.IdProduct)
			WHERE p.Description = @P AND s.IsDeleted = 0 AND p.IsDeleted = 0 AND st.IsDeleted = 0
			GROUP BY p.Description, p.BuyPrice, st.Qty, (p.BuyPrice*2)
			ORDER BY SUM(s.ResultPrice) DESC
		END
	ELSE
		BEGIN
			SELECT p.Description AS 'Product', 
					p.BuyPrice AS 'Buy price', 
					st.Qty AS 'Quantity on store', 
					(p.BuyPrice*2) AS 'Sale Price', 
					SUM(s.ResultPrice) AS 'Sold for'
			FROM Product p JOIN 
					Sale s ON (p.IdProduct = s.IdProduct) JOIN 
					Store st ON (st.IdProduct = p.IdProduct)
			WHERE s.IsDeleted = 0 AND p.IsDeleted = 0 AND st.IsDeleted = 0
			GROUP BY p.Description, p.BuyPrice, st.Qty, (p.BuyPrice*2)
			ORDER BY SUM(s.ResultPrice) DESC
		END
GO

EXEC productInfo NULL
EXEC productInfo 'Semka'

ALTER PROC cardInfo
	@C NVARCHAR(12)
AS
SELECT @C AS 'Card Number',
		b.QtyBonus AS 'Bonus Quantity',
		(d.Points - b.QtyBonus) AS 'Bonuses Needed',
		d.NameDiscount AS 'Discount Type',
		d.[Percent] AS 'Discount'
FROM Bonus b JOIN 
	Discount d ON (b.IdDiscount = d.IdDiscount)
WHERE (d.Points - b.QtyBonus) > 0 AND b.CardNum = @C
GO

EXEC cardInfo '741852963145'
