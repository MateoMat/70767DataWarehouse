USE [SSISExmpl]
GO

-------------------------------------------------------------------------------------------

	CREATE VIEW vw_DimProduct
	AS

	SELECT
			pl.[SystemID]		
		,	pl.[BusinessID]	
		,	pl.[Name]			
		,	pl.[Desc]			
		,	pp.[Price]			
	FROM
				[dbo].[ProductList]		AS pl
	INNER JOIN	[dbo].[ProductPrices]	AS pp ON pl.[SystemID] = pp.[SystemID]
	GO

-------------------------------------------------------------------------------------------

	CREATE PROC usp_ReloadDimProduct
	AS
	BEGIN

		TRUNCATE TABLE [dbo].[DimProduct]
		;

		INSERT INTO [dbo].[DimProduct]
		( 
			[SystemID]
		,	[BusinessID]
		,	[Name]
		,	[Desc]
		,	[Price]
		)
		SELECT 
			[SystemID]
		,	[BusinessID]
		,	[Name]
		,	[Desc]
		,	[Price]
		FROM [dbo].[vw_DimProduct]


	END