USE [TestDB]
GO

-- Propozycja #2 -> Dopchajmy wymiar pozycjami, które siê nie pojawi³yw Emp, a pojawi³y w Paym
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

	--	VVV tutaj zmiana VVV --

    INSERT  INTO [dest].[DimEmployee]
    (		[EmpId]
		,	[EmpFirstName]
		,	[EmpLastName]
	)
    SELECT DISTINCT
        [EmpId]
    ,   '!Nieznany'
    ,   '!Nieznany'
    FROM
        [src].[Payments] AS p
	WHERE
		p.[EmpId] NOT IN (SELECT [EmpId] FROM [dest].[DimEmployee])


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
	LEFT JOIN	[dest].[DimEmployee]	AS e ON [e].[EmpId] = [p].[EmpId]
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

	--	wygl¹da OK!

	--	dodatkowo gdzieœ na boku tworzymy raport
	--	który listuje wszystkie pozycje "dopchane" i wysy³amy do uzupe³nienia i poprawienia w systemach

	SELECT *
	FROM [dest].[DimEmployee]
	WHERE [EmpFirstName] = '!Nieznany'

	--	rozwi¹zanie jest OK!