USE TestDB
GO

--	³adujemy przyk³adowe dane do tabel Ÿród³owych
----------------------------------------------------------------------------------------------------

	INSERT INTO HR_Employees
	(
			PESEL			
		,	EmpFirstName	
		,	EmpLastName		
		,	DateOfBirth		
	)
	VALUES
		('87011001223',	'Marek'		,	'Kowalski'	,	'1985-01-10'),
		('77021001223',	'Bartosz'	,	'Nowak'		,	'1975-02-10'),
		('67031001223',	'Anna'		,	'Mazur'		,	'1965-03-10'),
		('97041001223',	'Katarzyna'	,	'Dudek'		,	'1995-04-10')

	INSERT INTO FIN_Payroll
	(
			PESEL			
		,	Salary			
		,	BonusRate		
	)
	VALUES
		('87011001223',	10000, 10),
		('77021001223',	7000, 10),
		('67031001223',	12000, 15),
		('97041001223',	9000, 8)


	INSERT INTO ORG_Structure
	(
			PESEL			
		,	JobPosition		
		,	TeamName		
	)
	VALUES
		('87011001223',	'Specjalista ds. Controllingu'			,	'Zespó³ ds. Controllingu i sprawozdawczoœci Finansowej'),
		('77021001223',	'Specjalista ds. Controllingu'			,	'Zespó³ ds. Controllingu i sprawozdawczoœci Finansowej'),
		('67031001223',	'Kierownik'								,	'Zespó³ ds. Controllingu i sprawozdawczoœci Finansowej'),
		('97041001223',	'M³odszy Specjalista ds. Controllingu'	,	'Zespó³ ds. Controllingu i sprawozdawczoœci Finansowej')

--	sprawdzenie zawartoœci oraz JOIN, za pomoc¹ którego wype³nimy wymiar
----------------------------------------------------------------------------------------------------

	SELECT TOP 10 * FROM  HR_Employees
	SELECT TOP 10 * FROM  FIN_Payroll
	SELECT TOP 10 * FROM  ORG_Structure

	SELECT
		hr.[PESEL]
	,	hr.[EmpFirstName]
	,	hr.[EmpLastName]
	,	hr.[DateOfBirth]
	,	fi.[Salary]
	,	fi.[BonusRate]
	,	og.[JobPosition]
	,	og.[TeamName]
	FROM
				[dbo].[HR_Employees]	AS hr
	INNER JOIN  [dbo].[FIN_Payroll]		AS fi	ON hr.[PESEL]	= fi.[PESEL]
	INNER JOIN  [dbo].[ORG_Structure]	AS og	ON hr.[PESEL]	= og.[PESEL]