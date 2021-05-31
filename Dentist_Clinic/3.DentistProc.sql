USE DB_Dentist
GO

CREATE OR ALTER PROC Employee_INFO
AS
BEGIN
SELECT CASE WHEN e.MidName IS NULL
			THEN e.FirstName+' '+e.LastName
			ELSE e.FirstName+' '+e.LastName+' '+e.MidName
			END AS 'FIO', 
			j.NameJob AS 'Job',
			e.Gender,
			e.Age,
			e.Phone,
			e.HireDate AS 'Hired',
			c.NameCitizenship AS 'Citizenship',
			DATEDIFF(yy, e.HireDate, getdate()) AS 'Seniority'
FROM Employee e 
	JOIN Job j ON (e.IdJob = j.IdJob) 
	JOIN Citizenship c ON (e.IdCitezenship = c.IdCitizenship)
WHERE e.IsDeleted = 0
ORDER BY e.IdEmployee
END
GO

EXEC Employee_INFO
GO

CREATE OR ALTER PROC Client_INFO
AS
BEGIN
SELECT CASE WHEN c.MidName IS NULL
			THEN c.FirstName+' '+c.LastName
			ELSE c.FirstName+' '+c.LastName+' '+c.MidName
			END AS 'FIO', 
			c.Gender,
			c.Phone,
			c.Subscribe AS 'Email',
			c.CardNum,
			d.NameDiscount AS 'Type Discount',
		CASE WHEN c.IsPension = 1
			THEN d.PercentDiscount + 5.00
			ELSE d.PercentDiscount
			END AS 'Discount',
		CASE WHEN c.IsPension = 1
			THEN 'Pension'
			ELSE 'Normal'
			END AS 'Type'
FROM Client c 
	JOIN BonusCard b ON (c.CardNum = b.CardNum)
	JOIN Discount d ON (d.IdDiscount = b.IdDiscount)
WHERE c.IsDeleted = 0
ORDER BY c.IdClient
END
GO

EXEC Client_INFO
GO

CREATE OR ALTER PROC Session_INFO
AS
BEGIN
SELECT CASE WHEN c.MidName IS NULL
			THEN c.FirstName+' '+c.LastName
			ELSE c.FirstName+' '+c.LastName+' '+c.MidName
			END AS 'FIO Client',
		CASE WHEN e.MidName IS NULL
			THEN e.FirstName+' '+e.LastName
			ELSE e.FirstName+' '+e.LastName+' '+e.MidName
			END AS 'FIO Employee',
			s.NameService AS 'Service',
			r.TimeSession AS 'Time',
			s.PriceService AS 'Price'
FROM Reception r
	JOIN Employee e ON (e.IdEmployee = r.IdEmployee)
	JOIN Client c ON (c.IdClient = r.IdClient)
	JOIN PriceList s ON (s.IdService = r.IdService)
WHERE e.IsDeleted = 0 AND c.IsDeleted = 0 AND s.IsDeleted = 0
ORDER BY r.IdSession
END
GO

EXEC Session_INFO
GO 

 CREATE OR ALTER PROC Store_INFO
 AS
 BEGIN
SELECT 	m.NameMed AS 'Medicament',
		s.IdPos AS 'Position',
		s.Qty AS 'Quantity',
		s.LastArr AS 'Last arrival',
		p.NameProv AS 'Provided by',
		m.Price,
	CASE WHEN p.Email IS NULL
		THEN p.Phone
		ELSE p.Email
		END AS 'Contact'
FROM Store s
	JOIN Medicaments m ON (m.IdMed = s.IdMed)
	JOIN [Provider] p ON (p.IdProv = m.IdProvBy)
WHERE s.IsDeleted = 0 AND p.IsDeleted = 0
ORDER BY m.NameMed
END
GO

EXEC Store_INFO
GO

CREATE OR ALTER PROC Card_INFO
AS
	DECLARE @T DECIMAL(4,0), @D INT
BEGIN
	SELECT b.CardNum AS 'Card Number',
		CASE WHEN c.MidName IS NULL
			THEN c.FirstName+' '+c.LastName
			ELSE c.FirstName+' '+c.LastName+' '+c.MidName
			END AS 'FIO Client',
			b.QtyBonus AS 'Bonuses',
			d.NameDiscount AS 'Rank',
			d.PercentDiscount AS 'Discount',
			(SELECT MIN(ThresholdBonus) 
				FROM Discount 
				WHERE ThresholdBonus > b.QtyBonus) - b.QtyBonus AS 'Bonuses Needed'
	FROM BonusCard b JOIN 
			Client c ON (b.CardNum = c.CardNum) JOIN
			Discount d ON (b.IdDiscount = d.IdDiscount)
	WHERE c.IsDeleted = 0
END
GO

EXEC Card_INFO
GO

-- Overall statistics for services
CREATE OR ALTER PROC Service_STAT
AS
BEGIN
	SELECT p.NameService AS 'Service',
			COUNT(r.IdService) AS 'Done Times'
	FROM Reception r JOIN PriceList p ON (r.IdService = p.IdService)
	GROUP BY p.NameService
	ORDER BY COUNT(r.IdService) DESC
END
GO

EXEC Service_STAT
GO

