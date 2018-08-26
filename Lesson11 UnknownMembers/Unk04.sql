USE [TestDB]
GO

-- Propozycja #1 -> zmieniamy na LEFT JOIN
-------------------------------------------------

-- Czyszczenie
-------------------------------------------------

	TRUNCATE TABLE [dest].[DimEmployee]
	TRUNCATE TABLE [dest].[FactPayment]
	;

-- ³adowanie wymiaru
-------------------------------------------------

    INSERT  INTO [dest].[DimEmployee]
    (		[EmpId]
		,	[EmpFirstName]
		,	[EmpLastName]
	)
    SELECT
        [EmpId]
    ,   [EmpFirstName]
    ,   [EmpLastName]
    FROM
        [src].[Emps]
	;

-- ³adowanie faktów
-------------------------------------------------

	--	problem #1: sk¹d zabraæ DimEmployeeKey
	--	rozwi¹zanie: JOIN do wymiaru

	INSERT INTO [dest].[FactPayment]
	(		[PaymentId]
		,	[DimEmployeeKey]
		,	[DateId]
		,	[Amount]
	)
	SELECT 
		[p].[PaymentId]
    ,	[e].[DimEmployeeKey]
    ,	[p].[DateId]
    ,	[p].[Amount]
	FROM 
				[src].[Payments]		AS p
	LEFT JOIN	[dest].[DimEmployee]	AS e ON [e].[EmpId] = [p].[EmpId]		--	<<<=== tutaj zmiana
	;

-- sprawdzamy
-------------------------------------------------
	
	SELECT * FROM [dest].[DimEmployee]
	SELECT * FROM [dest].[FactPayment]
	;

	-- wygl¹da OK!

--	sprawdzamy dok³adniej
--	czy suma systemu Ÿród³owego = suma DWH
-------------------------------------------------

	SELECT SUM([Amount])
	FROM [src].[Payments]

	SELECT SUM([Amount])
	FROM [dest].[FactPayment]

	-- wygl¹da OK!

--	sprawdzamy jeszcze dok³adniej
-------------------------------------------------

	SELECT [p].[EmpId], SUM([Amount])
	FROM [src].[Payments] AS p
	GROUP BY [p].[EmpId]

	SELECT [e].[EmpId], SUM([Amount])
	FROM [dest].[FactPayment] AS p
	INNER JOIN [dest].[DimEmployee] AS e ON [e].[DimEmployeeKey] = [p].[DimEmployeeKey]
	GROUP BY [e].[EmpId]

	SELECT *
	FROM [dest].[FactPayment] AS p
	WHERE	[p].[DimEmployeeKey] IS NULL

	--	jest Ÿle...
	--	lepiej, ale ci¹gle Ÿle