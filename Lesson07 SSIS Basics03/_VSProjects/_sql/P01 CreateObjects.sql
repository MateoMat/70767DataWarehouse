USE [master]
GO

DROP DATABASE IF EXISTS [VSVariablesAndMoreDFTasks]
GO

CREATE DATABASE [VSVariablesAndMoreDFTasks]
GO

USE [VSVariablesAndMoreDFTasks]
GO

CREATE TABLE t01_VarInsert
(
	kolumnaZTekstem		VARCHAR(100)
,	kolumnaZData		DATETIME	
,	kolumnaZLiczba		INT
)
GO

SELECT *
FROM t01_VarInsert

----------------------------------------------------------------------

CREATE TABLE [t02_CopyColCharacterMap]
    (
     [StoreManager] INT
    ,[StoreType] NVARCHAR(15)
    ,[StoreName] NVARCHAR(100)
    ,[StoreDescription] NVARCHAR(300)
    ,[Status] NVARCHAR(20)
    ,[OpenDate] DATETIME
    ,[CloseDate] DATETIME
    ,[AddressLine1] NVARCHAR(100)
    ,[AddressLine2] NVARCHAR(100)
    ,[CopyAddressLine1] NVARCHAR(100)
    ,[CopyAddressLine2] NVARCHAR(100)
    ,[LoadDate] DATETIME DEFAULT GETDATE()
    );

	SELECT *
	FROM [t02_CopyColCharacterMap]
	;

----------------------------------------------------------------------

    CREATE TABLE [t03_Pivot]
        (
         [CostType] NVARCHAR(200)
        ,[C_2007_CostAmount] MONEY
        ,[C_2008_CostAmount] MONEY
        ,[C_2009_CostAmount] MONEY
        ,[LoadDate] DATETIME DEFAULT GETDATE()
        );

	SELECT *
	FROM [t03_Pivot]

----------------------------------------------------------------------