SELECT
	[FolderPath]	=	REPLACE(c.[EnglishProductCategoryName]		,' ','')	+ '\' +
						REPLACE(s.[EnglishProductSubcategoryName]	,' ','')	+ '\'
,	[ProductKey]	=	p.[ProductKey]
FROM	
			[dbo].[DimProduct]				AS p
INNER JOIN	[dbo].[DimProductSubcategory] 	AS s	ON [s].[ProductSubcategoryKey] = [p].[ProductSubcategoryKey]
INNER JOIN	[dbo].[DimProductCategory]		AS c	ON [c].[ProductCategoryKey] = [s].[ProductCategoryKey]
;

SELECT
	[FolderPath]	=	REPLACE(c.[EnglishProductCategoryName]		,' ','')	+ '\' +
						REPLACE(s.[EnglishProductSubcategoryName]	,' ','')	+ '\'
,	[ProductKey]	=	p.[ProductKey]
FROM	
			[dbo].[DimProduct]				AS p
INNER JOIN	[dbo].[DimProductSubcategory] 	AS s	ON [s].[ProductSubcategoryKey] = [p].[ProductSubcategoryKey]
INNER JOIN	[dbo].[DimProductCategory]		AS c	ON [c].[ProductCategoryKey] = [s].[ProductCategoryKey]
WHERE p.[ProductKey] IN (SELECT f.[ProductKey] FROM [dbo].[FactInternetSales] AS f)
;