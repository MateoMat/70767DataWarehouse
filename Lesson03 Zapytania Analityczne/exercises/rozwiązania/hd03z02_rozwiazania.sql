USE [AdventureworksDW2016CTP3]
GO

--	Przygotowanie danych:
------------------------------------------------------

	IF OBJECT_ID('tempdb..#Dane')		IS NOT NULL DROP TABLE #Dane
	IF OBJECT_ID('tempdb..#DaneAggr')	IS NOT NULL DROP TABLE #DaneAggr

	SELECT 
		a.AccountType			, 
		o.OrganizationName		,
		d.[DepartmentGroupName]	,
		SUM(f.Amount)		AS [Amount]
	INTO #Dane
	FROM 
				[dbo].[FactFinance]				AS	f
	INNER JOIN	[dbo].[DimAccount]				AS	a	ON [a].AccountKey			= [f].[AccountKey]
	INNER JOIN	[dbo].[DimOrganization]			AS	o	ON [o].OrganizationKey		= [f].[OrganizationKey]
	INNER JOIN	[dbo].[DimDepartmentGroup]		AS	d	ON [d].[DepartmentGroupKey] = [f].[DepartmentGroupKey]
	GROUP BY
		a.[AccountType]			, 
		o.[OrganizationName]	,
		d.[DepartmentGroupName]	

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
	,	MAX(d.Amount)			AS [MaxAmount]
	,	SUM(d.Amount)			AS [MinAmoount]
	,	SUM(d.Amount)			AS [Amount]
	INTO [#DaneAggr]
	FROM [#Dane] AS d
	GROUP BY GROUPING SETS(	(d.AccountType)			,
							(d.OrganizationName)	,
							(d.DepartmentGroupName)
						)
	ORDER BY GROUPING_ID(d.AccountType, OrganizationName,d.DepartmentGroupName)

	SELECT TOP 10 *
	FROM [#DaneAggr]

--	(1)
--	W tabeli [#DaneAggr] dla ka¿dego wiersza wyliczyæ udzia³ procentowy Amount w ca³oœci Amount
--	tzn. dla DG znaleŸæ sumê Amount dla DG a potem podzieliæ i pomno¿yæ razy 100 
------------------------------------------------------

	SELECT 
			a.[TypGrupowania]				
	,		a.[Pozycja]						
	,		a.[Amount]						
	,		[TotalAmount]		=	SUM([Amount]) OVER (PARTITION BY a.[TypGrupowania])
	,		[PercAmountInTotal]	=	a.[Amount] / SUM([Amount]) OVER (PARTITION BY a.[TypGrupowania])
	FROM [#DaneAggr] AS a

--	(2)
--	skopiowaæ z 1, kolumnê z procentami zaokr¹gliæ do 4 miejsc po przecinku
--	posortowaæ wed³ug [TypGrupowania] a nastêpnie wed³ug udzia³u procentowego malej¹co
--	dodaæ kolumnê numeruj¹c¹ wiersze w ramach grupy
------------------------------------------------------

	SELECT 
		[rn]	=	ROW_NUMBER() OVER (	PARTITION BY a.[TypGrupowania]
										ORDER BY a.[Amount] DESC
										)
	,	a.[TypGrupowania]				
	,	a.[Pozycja]						
	,	a.[Amount]						
	,	[PercAmountInTotal]	=	ROUND(a.[Amount] / SUM([Amount]) OVER (PARTITION BY a.[TypGrupowania]), 4)
	FROM [#DaneAggr] AS a
	ORDER BY
		a.[TypGrupowania]	,
		[PercAmountInTotal]	DESC