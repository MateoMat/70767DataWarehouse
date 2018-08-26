USE [master]
GO

IF DB_ID('SSISExmpl') IS NOT NULL DROP DATABASE SSISExmpl
GO

CREATE DATABASE SSISExmpl
GO

USE SSISExmpl
GO

------------------------------------------------------------------

	CREATE TABLE [dbo].[FactInternetSales]
	(
		[ProductKey] [int] NOT NULL,
		[OrderDateKey] [int] NOT NULL,
		[DueDateKey] [int] NOT NULL,
		[ShipDateKey] [int] NOT NULL,
		[CustomerKey] [int] NOT NULL,
		[PromotionKey] [int] NOT NULL,
		[CurrencyKey] [int] NOT NULL,
		[SalesTerritoryKey] [int] NOT NULL,
		[SalesOrderNumber] [nvarchar](20) NOT NULL,
		[SalesOrderLineNumber] [tinyint] NOT NULL,
		[RevisionNumber] [tinyint] NOT NULL,
		[OrderQuantity] [smallint] NOT NULL,
		[UnitPrice] [money] NOT NULL,
		[ExtendedAmount] [money] NOT NULL,
		[UnitPriceDiscountPct] [float] NOT NULL,
		[DiscountAmount] [float] NOT NULL,
		[ProductStandardCost] [money] NOT NULL,
		[TotalProductCost] [money] NOT NULL,
		[SalesAmount] [money] NOT NULL,
		[TaxAmt] [money] NOT NULL,
		[Freight] [money] NOT NULL,
		[CarrierTrackingNumber] [nvarchar](25) NULL,
		[CustomerPONumber] [nvarchar](25) NULL,
		[OrderDate] [datetime] NULL,
		[DueDate] [datetime] NULL,
		[ShipDate] [datetime] NULL
	)

------------------------------------------------------------------

	CREATE TABLE [dbo].[LoadLog]
	(
		[ExecTime]	DATETIME
	,	[RowCount]	INT
	)
	GO