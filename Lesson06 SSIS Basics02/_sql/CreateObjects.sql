USE [master]
GO

IF DB_ID('SSISExmpl') IS NOT NULL DROP DATABASE SSISExmpl
GO

CREATE DATABASE SSISExmpl
GO

USE SSISExmpl
GO

------------------------------------------------------------------------------------------------

	CREATE TABLE [Pckg01_DerivedCols] (
		[SystemID] int,
		[BusinessID] varchar(3),
		[Name] varchar(50),
		[Desc] varchar(200),
		[DrvCol_Tekst] nvarchar(5),
		[DrvCol_LoadDate] datetime,
		[DrvCol_PckgId] nvarchar(38),
		[DrvCol_MachName] nvarchar(3)
	)

------------------------------------------------------------------------------------------------

	CREATE TABLE [ProductsA] (
		[SystemID] int,
		[BusinessID] varchar(3),
		[Name] varchar(50),
		[Desc] varchar(200)
	)

	CREATE TABLE [ProductsOther] (
		[SystemID] int,
		[BusinessID] varchar(3),
		[Name] varchar(50),
		[Desc] varchar(200)
	)

------------------------------------------------------------------------------------------------

	CREATE TABLE [TblAggregate] (
		[BusinessID] varchar(3),
		[Quantity] bigint,
		[Quantity_Avg] float,
		[Quantity_Min] int,
		[Quantity_Max] int
	)

------------------------------------------------------------------------------------------------

	CREATE TABLE [Pckg04_Prices] (
		[System_Id] int,
		[Product_Id] varchar(3),
		[Price] real
	)

	CREATE TABLE [Pckg04_Products] (
		[SystemID] int,
		[BusinessID] varchar(3),
		[Name] varchar(50),
		[Desc] varchar(200),
		[Price] real
	)

------------------------------------------------------------------------------------------------

	CREATE TABLE [Pckg05_DateConvers] (
		[BusinessID] varchar(3),
		[Quantity] int,
		[Year] varchar(20),
		[Year_DT] datetime
	)

------------------------------------------------------------------------------------------------

	CREATE TABLE [CopyA] (
		[SystemID] int,
		[BusinessID] varchar(3),
		[Name] varchar(50),
		[Desc] varchar(200)
	)

	CREATE TABLE [CopyB] (
		[SystemID] int,
		[BusinessID] varchar(3),
		[Name] varchar(50),
		[Desc] varchar(200)
	)

	CREATE TABLE [CopyC] (
		[SystemID] int,
		[BusinessID] varchar(3),
		[Name] varchar(50),
		[Desc] varchar(200)
	)

------------------------------------------------------------------------------------------------

	CREATE TABLE [Pckg07_UnionAllProds] (
		[SystemID] int,
		[BusinessID] varchar(3),
		[Name] varchar(50),
		[Desc] varchar(200)
	)

------------------------------------------------------------------------------------------------

	CREATE TABLE [Pckg08_MergeJoin] (
		[Left_SystemID] int,
		[Left_BusinessID] varchar(3),
		[Left_Name] varchar(50),
		[Left_Desc] varchar(200),
		[Right_System_Id] int,
		[Right_Product_Id] varchar(3),
		[Right_Price] real
	)

------------------------------------------------------------------------------------------------

	

------------------------------------------------------------------------------------------------

	

------------------------------------------------------------------------------------------------

