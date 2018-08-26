USE TestDB
GO


----------------------------------------------------------------------------------------------------
--
--
--	http://dwgeek.com/scd-type-2-sql.html/
--	https://www.mssqltips.com/sqlservertip/2883/using-the-sql-server-merge-statement-to-process-type-2-slowly-changing-dimensions/
----------------------------------------------------------------------------------------------------

--
--	je¿eli w bazie znajduj¹ siê ju¿ tabele u¿ywane w przyk³adzie to zostan¹ skasowane
--	poni¿szy kod gwarantuje dzia³anie dalszych czêœci skryptu
--
--	doczytaæ o: 1) funkcja OBJECT_ID(), 2) polecenie IF
--
----------------------------------------------------------------------------------------------------

	IF OBJECT_ID('dbo.HR_Employees')		IS NOT NULL DROP TABLE dbo.HR_Employees		
	IF OBJECT_ID('dbo.FIN_Payroll')			IS NOT NULL DROP TABLE dbo.FIN_Payroll		
	IF OBJECT_ID('dbo.ORG_Structure')		IS NOT NULL DROP TABLE dbo.ORG_Structure	
	IF OBJECT_ID('dbo.DWH_DimEmployeeSCD2') IS NOT NULL DROP TABLE dbo.DWH_DimEmployeeSCD2

--	
--	Tworzymy trzy tabele symuluj¹ce 3 systemy Ÿród³owe -> dane pracownicze z systemów Kadrowych: 
	--	HR (dane osobowe), 
	--	FIN (finanse, p³ace, premie), 
	--	ORG (struktura organizacyjna)

--	kluczem biznesowym pozwol¹cym nam ³¹czyæ dane z tabel jest PESEL
--	klucze techniczne s¹ u¿ywane jedynie w systemie Ÿród³owym, nie s¹ mam potrzebne i nie mamy gwarancji zgodnoœci (SystemID)
----------------------------------------------------------------------------------------------------

	CREATE TABLE [dbo].[HR_Employees]
	(
			SystemID		INT				NOT NULL	IDENTITY(1,1) PRIMARY KEY
		,	PESEL			CHAR(11)		NOT NULL	UNIQUE
		,	EmpFirstName	VARCHAR(100)	NOT NULL
		,	EmpLastName		VARCHAR(100)	NOT NULL
		,	DateOfBirth		DATE			NOT NULL
	)
	GO

	CREATE TABLE [dbo].[FIN_Payroll]
	(
			SystemID		INT				NOT NULL	IDENTITY(1,1) PRIMARY KEY
		,	PESEL			CHAR(11)		NOT NULL	UNIQUE
		,	Salary			MONEY			NOT NULL
		,	BonusRate		INT				NOT NULL
	)
	GO

	CREATE TABLE [dbo].[ORG_Structure]
	(
			SystemID		INT				NOT NULL	IDENTITY(1,1) PRIMARY KEY
		,	PESEL			CHAR(11)		NOT NULL	UNIQUE
		,	JobPosition		VARCHAR(100)	NOT NULL	
		,	TeamName		VARCHAR(100)	NOT NULL	
	)
	GO

--	
--	Tabela DimEmployee -> wymiar "Pracownik"
--	³¹czy w sobie dane z wszystkich systemów, trzyma zmiany jako SCD2 (na koñcu kolumny "Od", "Do", "Aktywny")
----------------------------------------------------------------------------------------------------

	CREATE TABLE [dbo].[DWH_DimEmployeeSCD2]
	(
			[Id]				INT				NOT NULL IDENTITY(1,1) PRIMARY KEY
		,	[PESEL]				CHAR(11)		NOT NULL
		,	[EmpFirstName]		VARCHAR(100)	NOT NULL
		,	[EmpLastName]		VARCHAR(100)	NOT NULL
		,	[DateOfBirth]		DATE			NOT NULL
		,	[Salary]			MONEY			NOT NULL
		,	[BonusRate]			INT				NOT NULL
		,	[JobPosition]		VARCHAR(100)	NOT NULL
		,	[TeamName]			VARCHAR(100)	NOT NULL

		,	[IsActive]			INT				NOT NULL
		,	[BegDateTime]		DATETIME2(0)	NOT NULL
		,	[EndDateTime]		DATETIME2(0)	NULL

		,	CONSTRAINT	PK_DWH_DimEmployeeSCD2 UNIQUE ([PESEL], [BegDateTime])
	)
	GO