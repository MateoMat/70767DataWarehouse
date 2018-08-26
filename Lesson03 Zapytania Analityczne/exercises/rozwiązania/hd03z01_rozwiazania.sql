USE [AdventureworksDW2016CTP3]
GO
--	
--	Przygotowanie danych
------------------------------------------------------

	IF OBJECT_ID('tempdb..#Dane') IS NOT NULL DROP TABLE #Dane

	SELECT 
		a.AccountType			, 
		o.OrganizationName		,
		d.[DepartmentGroupName]	,
		SUM(f.Amount)		AS [Amount]
	INTO #Dane
	FROM 
				[dbo].[FactFinance]			AS	f
	INNER JOIN	[dbo].[DimAccount]			AS	a	ON [a].AccountKey			= [f].[AccountKey]
	INNER JOIN	[dbo].[DimOrganization]		AS	o	ON [o].OrganizationKey		= [f].[OrganizationKey]
	INNER JOIN	[dbo].[DimDepartmentGroup]	AS	d	ON [d].[DepartmentGroupKey] = [f].[DepartmentGroupKey]
	GROUP BY
		a.[AccountType]			, 
		o.[OrganizationName]	,
		d.[DepartmentGroupName]	

	SELECT TOP 10 *
	FROM [#Dane]

--	(1)
--	Pogupowaæ #Dane po Account Type
--	Dla ka¿dego Account Type wyœwietliæ:
--	nazwa
--	liczbê wierszy w grupie
--	Sumê pozycji Amount
--	MAX, MIN i AVG na kolumnie Amount
------------------------------------------------------

	SELECT 
		d.AccountType	
	,	COUNT(*)			AS [cnt]
	,	MIN(d.Amount)		AS [min_Amount]
	,	MAX(d.Amount)		AS [max_Amount]
	,	AVG(d.Amount)		AS [avg_Amount]
	,	SUM(d.Amount)		AS [Amount]
	FROM [#Dane] AS d
	GROUP BY
		d.AccountType

--	(2)
--	To Samo co w (1)
--	dodatkowo wyœwietliæ wiersz z TOTALem - grupowanie wszystkiego po ca³oœci (np. za pomoc¹ ROLLUP)
--	posortowaæ tak, ¿eby TOTAL by³ na samej górze
--	dla TOTAL podmieniæ kolumnê AccountType na "Total"
------------------------------------------------------

	SELECT 
		CASE
			WHEN GROUPING_ID(d.AccountType) = 1
			THEN 'TOTAL'
			ELSE d.AccountType	
			END
	,	COUNT(*)
	,	MIN(d.Amount)
	,	MAX(d.Amount)
	,	SUM(d.Amount)
	,	SUM(d.Amount)		AS [Amount]
	FROM [#Dane] AS d
	GROUP BY ROLLUP(d.AccountType)
	ORDER BY GROUPING_ID(d.AccountType) DESC

--	(3)
--	To Samo co w (1)
--	maj¹ pojawiæ siê nastêpuj¹ce grupy: 
	--	[AccountType]			-	podzia³ per konto
	--	[OrganizationName]		-	podzia³ per organizacja
	--	[DepartmentGroupName]	-	podzia³ per department
--	posortowaæ tak, ¿eby nie miesza³y siê miêdzy sob¹ grupowania -> najpierw AT, potem ON, potem DG
------------------------------------------------------

	SELECT 
		d.AccountType
	,	d.OrganizationName
	,	d.DepartmentGroupName	
	,	COUNT(*)
	,	MAX(d.Amount)
	,	SUM(d.Amount)
	,	SUM(d.Amount)			AS [Amount]
	FROM [#Dane] AS d
	GROUP BY GROUPING SETS(	(d.AccountType)			,
							(d.OrganizationName)	,
							(d.DepartmentGroupName)
						)
	ORDER BY GROUPING_ID(d.AccountType, OrganizationName,d.DepartmentGroupName)

--	(4)
--	To Samo co w (3), ale zrobiæ jedn¹ kolumnê w której pojawi siê nazwa AT/ON/DG
--	oraz kolumnê [TypGrupowania] która przyjmie wartoœci AT, ON, DG w zale¿noœci od tego, po czym grupujemy
------------------------------------------------------

	SELECT
		CASE GROUPING_ID(d.AccountType, OrganizationName,d.DepartmentGroupName)
			WHEN 3 THEN	'AT'
			WHEN 5 THEN	'ON'
			WHEN 6 THEN	'DG'
			END [TypGrupowania] 
	,	CASE GROUPING_ID(d.AccountType, OrganizationName,d.DepartmentGroupName)
			WHEN 3 THEN	d.AccountType
			WHEN 5 THEN	d.OrganizationName
			WHEN 6 THEN	d.DepartmentGroupName
			END [Pozycja] 	
	,	COUNT(*)
	,	MAX(d.Amount)
	,	SUM(d.Amount)
	,	SUM(d.Amount)			AS [Amount]
	FROM [#Dane] AS d
	GROUP BY GROUPING SETS(	(d.AccountType)			,
							(d.OrganizationName)	,
							(d.DepartmentGroupName)
						)
	ORDER BY GROUPING_ID(d.AccountType, OrganizationName,d.DepartmentGroupName)