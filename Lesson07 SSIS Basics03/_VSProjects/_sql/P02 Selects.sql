USE [ZadanieSCD2]
GO

	SELECT *
	FROM [dbo].[LoadLogger]

	SELECT p.*
	FROM [dbo].[DimProductSCD2] AS p
	WHERE p.[ProductID] IN (SELECT [ProductID] FROM [dbo].[DimProductSCD2] GROUP BY [ProductID] HAVING COUNT(*) > 1)
	ORDER BY [ProductID], [DateFrom]

-----------------------------------------------------
	SELECT p.*
	FROM [dbo].[DimProductSCD2] AS p
	WHERE p.[ProductID] IN (-1,-2,-3)

-----------------------------------------------------

	SELECT p.*
	FROM [dbo].[DimProductSCD2] AS p
	WHERE p.[ProductID] IN (680,706,709)
	ORDER BY [ProductID], [DateFrom]

	--DELETE
	--FROM [dbo].[DimProductSCD2]
	--WHERE [ProductKey] IN (312,313,314)