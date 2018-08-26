
--	sprawdzamy, co ju¿ jest w tabeli:

	SELECT *
	FROM	[dbo].[DWH_DimEmployeeSCD2]
	ORDER BY PESEL, IsActive

--	odpalamy ³adowanie:

	EXEC [dbo].[usp_Reload_DWH_DimEmployeeSCD2]

--	sprawdzamy, czy siê za³adowa³o:

	SELECT *
	FROM	[dbo].[DWH_DimEmployeeSCD2]
	ORDER BY PESEL, IsActive

------------------------------------------------------------------------------------------------

--	wprowadzamy zmiany:

--	1)	Kowalski to tak na prawdê Kowalewski, poprawiamy w HR
--	2)	Mazur dosta³a podwy¿kê
--	3)	Dudek awansowa³a

	UPDATE [dbo].[HR_Employees]
	SET EmpLastName = 'Kowalewski'
	WHERE PESEL = '87011001223'

	UPDATE [dbo].[FIN_Payroll]
	SET Salary = 12500
	WHERE PESEL = '67031001223'

	UPDATE [dbo].[ORG_Structure]
	SET JobPosition = 'Specjalista ds. Controllingu'
	WHERE PESEL = '97041001223'

--	odpalamy ³adowanie:

	EXEC [dbo].[usp_Reload_DWH_DimEmployeeSCD2]

--	sprawdzamy, czy siê zmieni³o:

	SELECT *
	FROM	[dbo].[DWH_DimEmployeeSCD2]
	ORDER BY PESEL, IsActive

	
--	wprowadzamy zmiany:

--	1)	Dudek Odchodzi
--	2)	Zespó³ zmienia nazwê na 'Zespó³ ds. Controllingu'
	
	DELETE 
	FROM [dbo].[HR_Employees]
	WHERE PESEL = '97041001223'

	DELETE 
	FROM [dbo].[FIN_Payroll]
	WHERE PESEL = '97041001223'

	DELETE 
	FROM [dbo].[ORG_Structure]
	WHERE PESEL = '97041001223'

	UPDATE [ORG_Structure]
	SET TeamName = 'Zespó³ ds. Controllingu'
	WHERE TeamName = 'Zespó³ ds. Controllingu i sprawozdawczoœci Finansowej'

--	odpalamy ³adowanie:

	EXEC [dbo].[usp_Reload_DWH_DimEmployeeSCD2]

--	sprawdzamy, czy siê zmieni³o:

	SELECT *
	FROM	[dbo].[DWH_DimEmployeeSCD2]
	ORDER BY PESEL, IsActive
