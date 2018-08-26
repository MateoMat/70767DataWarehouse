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

--	(2)
--	To Samo co w (1)
--	dodatkowo wyœwietliæ wiersz z TOTALem - grupowanie wszystkiego po ca³oœci (np. za pomoc¹ ROLLUP)
--	posortowaæ tak, ¿eby TOTAL by³ na samej górze
--	dla TOTAL podmieniæ kolumnê AccountType na "Total"
------------------------------------------------------


--	(3)
--	To Samo co w (1)
--	maj¹ pojawiæ siê nastêpuj¹ce grupy: 
	--	[AccountType]			-	podzia³ per konto
	--	[OrganizationName]		-	podzia³ per organizacja
	--	[DepartmentGroupName]	-	podzia³ per department
--	posortowaæ tak, ¿eby nie miesza³y siê miêdzy sob¹ grupowania -> najpierw AT, potem ON, potem DG
------------------------------------------------------


--	(4)
--	To Samo co w (3), ale zrobiæ jedn¹ kolumnê w której pojawi siê nazwa AT/ON/DG
--	oraz kolumnê [TypGrupowania] która przyjmie wartoœci AT, ON, DG w zale¿noœci od tego, po czym grupujemy
------------------------------------------------------

