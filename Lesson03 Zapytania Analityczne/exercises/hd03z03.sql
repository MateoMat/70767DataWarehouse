USE [AdventureworksDW2016CTP3]
GO
--	Przygotowanie danych:
--	wyci¹gamy konta Aktywów, wg dat
------------------------------------------------------

	SELECT 
		f.[Date]			AS [Date],
		SUM(f.Amount)		AS [Amount]
	INTO #Dane
	FROM 
				[dbo].[FactFinance]				AS	f
	INNER JOIN	[dbo].[DimAccount]				AS	a	ON [a].AccountKey			= [f].[AccountKey]
	INNER JOIN	[dbo].[DimOrganization]			AS	o	ON [o].OrganizationKey		= [f].[OrganizationKey]
	INNER JOIN	[dbo].[DimDepartmentGroup]		AS	d	ON [d].[DepartmentGroupKey] = [f].[DepartmentGroupKey]
	WHERE 1=1
	AND a.[AccountType] = 'Assets'
	GROUP BY
		f.[Date]
	;

--	(1)
--	pokazaæ stan na koniec kwarta³u (zostawiæ tylko ostatnie daty w kwartale)
--	CTE + ROW_NUMBER() <- bardzo czêste po³¹czenie
------------------------------------------------------

--	(2)
--	wykorzystuj¹c dane z (1) przygotowaæ raport pokazuj¹cy zmianê wzglêdn¹ oraz bezwzglêdn¹ pomiêdzy nastêpuj¹cymi po sobie kwarta³ami
------------------------------------------------------
