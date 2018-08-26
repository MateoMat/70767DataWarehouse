USE [master]
GO

IF DB_ID('SSISExmpl') IS NOT NULL DROP DATABASE SSISExmpl
GO

CREATE DATABASE SSISExmpl
GO

USE SSISExmpl
GO

------------------------------------------------------------------------------------------------

	IF OBJECT_ID('dbo.ProductList')		IS NOT NULL DROP TABLE [dbo].[ProductList] 
	IF OBJECT_ID('dbo.ProductPrices')	IS NOT NULL DROP TABLE [dbo].[ProductPrices] 
	IF OBJECT_ID('dbo.DimProduct')		IS NOT NULL DROP TABLE [dbo].[DimProduct] 

	CREATE TABLE [dbo].[ProductList]
	(
			[SystemID]		[INT]			NULL
		,	[BusinessID]	[VARCHAR](3)	NULL
		,	[Name]			[VARCHAR](50)	NULL
		,	[Desc]			[VARCHAR](200)	NULL
	)

	CREATE TABLE [dbo].[ProductPrices]
	(
			[SystemID]		[INT]			NULL
		,	[BusinessID]	[VARCHAR](3)	NULL
		,	[Price]			[REAL]			NULL
	)

	CREATE TABLE [dbo].[DimProduct]
	(
			[DimProductKey]	[INT] NOT NULL IDENTITY(1,1) PRIMARY KEY
		,	[SystemID]		[INT]			NULL
		,	[BusinessID]	[VARCHAR](3)	NULL
		,	[Name]			[VARCHAR](50)	NULL
		,	[Desc]			[VARCHAR](200)	NULL
		,	[Price]			[REAL]			NULL
		,	[LoadDate]		[DATETIME]		NOT NULL	DEFAULT GETDATE()
		,	[LoadUser]		[VARCHAR](200)	NOT NULL	DEFAULT SUSER_SNAME()
	)
	GO

------------------------------------------------------------------------------------------------

	SELECT * FROM [dbo].[ProductList]
	SELECT * FROM [dbo].[ProductPrices]
	SELECT * FROM [dbo].[DimProduct]

	GO
















