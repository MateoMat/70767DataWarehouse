USE [TestDB]
GO

--	problem:
--	rozwi¹zanie #2 zak³ada, ¿e te sytuacje mog¹ istnieæ i powinny byæ poprawiane
--	mo¿e siê jednak okazaæ, ¿e tak nie jest, tzn:

	--	nie powinniœmy tworzyæ tych pracowników, bo s¹ zwolnieni
	--	dane finansowe nadal powinny byæ przenoszone w 100%
	--	chcemy wszystkie b³êdne dane mieæ w jednym miejscu - czyli jak siê pojawi kilka niepoprawnych u¿ytkownikó AB1, AB2, AB3, to chcemy
		-- mieæ ich wpisy na jednej pozycji wymiaru Employee

-- Propozycja #3		-> Dopychamy wymiar techniczny jednym u¿ytkownikiem "UNKNOWN"
					--	-> ³adujemy na niego wszystkie wpisy z niepoprawnym EmpId
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
    SELECT
        '!UN'
    ,   '!B³êdneWpisy'
    ,   '!B³êdneWpisy'


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

-- UPDATE
-------------------------------------------------

	--	b³êdne wpisy maj¹ [DimEmployeeKey] = NULL
	--	trzeba je zmieniæ na [DimEmployeeKey] wiersza UNKNOWN
	--	ale tego numeru nie znamy bo siê nadaje automatycznie
	--	tzn... teraz znamy bo jest 3'ci, ale w rzeczywistoœci mo¿e byæ dowolny

	-- pierwsze podejœcie ("brzydkie"), czêœæ a) oraz b) nale¿y odpaliæ RAZEM
		
		--	a) szukamy klucza

			DECLARE @UnknownKey INT 
			SET @UnknownKey = ( SELECT DimEmployeeKey
								FROM	[dest].[DimEmployee]
								WHERE [EmpId] = '!UN'
								)

			PRINT @UnknownKey

		--	b) nadpisujemy klucz

			UPDATE [dest].[FactPayment]
			SET [DimEmployeeKey] = @UnknownKey
			WHERE [DimEmployeeKey] IS NULL

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