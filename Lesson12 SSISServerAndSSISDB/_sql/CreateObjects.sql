USE [master]
GO

--	Drop Objects
--------------------------------------------------------------------

	DROP DATABASE IF EXISTS [SSISFromServer]
	GO

	CREATE DATABASE [SSISFromServer]
	GO

--	Create Objects
--------------------------------------------------------------------

	USE [SSISFromServer]
	GO

	DROP TABLE IF EXISTS [dbo].[tblExecutionLogs]
	DROP PROC IF EXISTS [dbo].[insertLog]
	GO

	CREATE TABLE [dbo].[tblExecutionLogs]
	(
			[LogID]			INT				NOT NULL IDENTITY(1,1) 
		,	[LogTime]		DATETIME		NOT NULL DEFAULT GETDATE()
		,	[LogUser]		NVARCHAR(200)	NOT NULL DEFAULT SUSER_SNAME()
		,	[LogMachine]	NVARCHAR(200)	NOT NULL DEFAULT HOST_NAME()
		,	[Parameter1]	NVARCHAR(100)	NULL
	)
	GO

	CREATE PROCEDURE [dbo].[insertLog]
		@Param1 NVARCHAR(100)
	AS 
	BEGIN 

		INSERT INTO tblExecutionLogs([Parameter1])
		VALUES(@Param1)

	END
	GO

--	Test Objects
--------------------------------------------------------------------

	EXEC [dbo].[insertLog]
			@Param1 = 'TestProcedury'
	GO

	SELECT *
	FROM [dbo].[tblExecutionLogs]
	GO
