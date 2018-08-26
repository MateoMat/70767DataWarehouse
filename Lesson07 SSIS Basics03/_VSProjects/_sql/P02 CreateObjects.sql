--CREATE DATABASE ZadanieSCD2
--GO

USE [ZadanieSCD2]
GO

--------------------------------------------

	DROP TABLE IF EXISTS [dbo].[DimProductReload]
	;

	CREATE TABLE [dbo].[DimProductReload]
	(
		[ProductKey]		[INT] IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[ProductID]			[INT] NULL,
		[Name]				[VARCHAR](50) NULL,
		[ProductNumber]		[VARCHAR](50) NULL,
		[Color]				[VARCHAR](50) NULL,
		[StandardCost]		[NUMERIC](18, 6) NULL,
		[ListPrice]			[NUMERIC](18, 6) NULL,
		[ProductLine]		[VARCHAR](50) NULL,
		[Class]				[VARCHAR](50) NULL,
		[Style]				[VARCHAR](50) NULL,
		[ModelName]			[NVARCHAR](50) NULL,
		[SubcategoryName]	[VARCHAR](50) NULL,
		[CategoryName]		[NVARCHAR](50) NULL,
		[LoadDate]			[DATETIME] NULL DEFAULT (GETDATE()),
		[LoadUser]			[VARCHAR](100) NULL DEFAULT (SUSER_SNAME())
	)

--------------------------------------------

	DROP TABLE IF EXISTS [dbo].[DimProductSCD2]
	;

	CREATE TABLE [dbo].[DimProductSCD2]
	(
		[ProductKey]		[INT] IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[ProductID]			[INT] NULL,
		[ProductName]		[VARCHAR](50)		NOT NULL,
		[ModelName]			[NVARCHAR](50)		NOT NULL,
		[SubcategoryName]	[VARCHAR](50)		NOT NULL,
		[CategoryName]		[NVARCHAR](50)		NOT NULL,
		[ProductNumber]		[VARCHAR](50)		NOT NULL,
		[StandardCost]		[NUMERIC](18, 6)	NOT NULL,
		[ListPrice]			[NUMERIC](18, 6)	NOT NULL,
		[DateFrom]			[DATETIME] NULL,
		[DateTo]			[DATETIME] NULL	DEFAULT (NULL),
		[Tech_LoadDate]		[DATETIME] NULL DEFAULT (GETDATE()),
		[Tech_LoadUser]		[VARCHAR](100) NULL DEFAULT (SUSER_SNAME())
	)

--------------------------------------------

	DROP TABLE IF EXISTS [dbo].[LoadLogger]
	;

	CREATE TABLE [dbo].[LoadLogger]
	(
		[LogId]			INT IDENTITY	NOT NULL PRIMARY KEY
	,	[LogDate]		DATETIME		NOT NULL DEFAULT GETDATE()
	,	[User]			VARCHAR(200)	NOT NULL DEFAULT SUSER_SNAME()
	,	[Host]			VARCHAR(200)	NOT NULL DEFAULT HOST_NAME()
	,	[RCAll]			INT NOT NULL
	,	[RCInsert]		INT NOT NULL
	,	[RCUpdate]		INT NOT NULL
	,	[RCDelete]		INT NOT NULL
	,	[RCNoAction]	INT NOT NULL
	,	[ISRCSumCorrect] AS CASE WHEN [RCAll] = [RCInsert] + [RCUpdate] + [RCDelete] + [RCNoAction] THEN 1 ELSE 0 END 
	)

