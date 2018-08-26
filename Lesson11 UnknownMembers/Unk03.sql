USE [TestDB]
GO

-- £adowanie danych
-------------------------------------------------

	--	klucze DimEmployeeKey oraz FactPaymentKey nadawane s¹ podczas towrzenia wierszy
	--	³aduj¹c tabelê dest.FactPayment potrzebujemy DimEmployeeKey, które utworzone zostanie podczas ³adownia dest.DimEmployee
	--
	--	z tego powodu oknieczne jest ³adowanie danych w kolejnoœci 1/ Wymiar, 2/ Fakt

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
	INNER JOIN	[dest].[DimEmployee]	AS e ON [e].[EmpId] = [p].[EmpId]
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

	-- jest Ÿle...

-- gdzie jest problem?
-------------------------------------------------

	SELECT *
	FROM 
				[src].[Payments] AS p
	LEFT JOIN	[src].[Emps] AS e ON [e].[EmpId] = [p].[EmpId]
	WHERE e.[EmpId] IS NULL

	--	w systemie Ÿród³owym s¹ braki
	--	na tabelach nie ma za³o¿onych fizycznych kluczy obcych
	--	i nie jest pilnowana poprawnoœæ danych
	--	ktoœ skasowa³ u¿ytkownika a jego p³atnoœci zosta³y

	--	b³¹d generuje "INNER JOIN" u¿yty do doci¹gniêcia klucza obcego przy ³adowaniu faktów

--	co z tym zrobiæ?
--	...