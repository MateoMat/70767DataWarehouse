USE [TestDB]
GO

-- Propozycja #3b		-> To samo co w #3 ale bardziej elegancko
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

	--	VVV tutaj zmiana VVV
	--	chcemy, ¿eby nasz '!UN' mia³ zawsze ten sam numer
	--	skoro IDENTITY nadaje numery od 1 w górê, to nadajmy mu numer (-1)


		--	ten kod wywo³a b³¹d
		--	Cannot insert explicit value for identity column in table 'DimEmployee' when IDENTITY_INSERT is set to OFF.

			INSERT  INTO [dest].[DimEmployee]
			(		[DimEmployeeKey]
				,	[EmpId]
				,	[EmpFirstName]
				,	[EmpLastName]
			)
			SELECT
				-1
			,	'!UN'
			,   '!B³êdneWpisy'
			,   '!B³êdneWpisy'

		--	domyœlnie nie da siê po prostu wpisaæ dowolnej liczby w kolumnê z IDENTITY
		--	ale da siê to wy³¹czyæ poleceniem IDENTITY_INSERT

		--	próbujemy jeszcze raz:

		SET IDENTITY_INSERT [dest].[DimEmployee] ON

			INSERT  INTO [dest].[DimEmployee]
			(		[DimEmployeeKey]
				,	[EmpId]
				,	[EmpFirstName]
				,	[EmpLastName]
			)
			SELECT
				-1
			,	'!UN'
			,   '!B³êdneWpisy'
			,   '!B³êdneWpisy'

		SET IDENTITY_INSERT [dest].[DimEmployee] OFF
		;

		--	powinno byæ ok:

		SELECT *
		FROM [dest].[DimEmployee]

-- ³adowanie faktów
-------------------------------------------------

	--	moglibyœmy zrobiæ to tak samo jak w #3 a potem wszystkie NULL'e podmieniæ na (-1)
	--	ale mo¿emy to zrobiæ jesze szybciej -> tzn, podmieniaæ je od razu a nie poprzez UPDATE:

		INSERT INTO [dest].[FactPayment]
		(		[PaymentId]
			,	[DimEmployeeKey]
			,	[DateId]
			,	[Amount]
		)
		SELECT 
			[p].[PaymentId]
		,	ISNULL([e].[DimEmployeeKey], -1)		--	<<== je¿eli jest NULL, to zamieñ na -1
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