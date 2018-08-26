USE [master]
GO

CREATE DATABASE [TestDB]
GO

USE [TestDB]
GO

CREATE SCHEMA src
--	system zrodlowy
GO

CREATE SCHEMA dest
--	system docelowy (HD)
GO

--	Tabela z danymi pracowników
--	w systemie Ÿród³owym
--------------------------------------------------

	CREATE TABLE src.Emps
	(
		EmpId			VARCHAR(3)		NOT NULL	PRIMARY KEY
	,	EmpFirstName	VARCHAR(100)	NOT NULL
	,	EmpLastName		VARCHAR(100)	NOT NULL
	)
	GO

	INSERT INTO [src].[Emps]
	VALUES('AKO','Adam','Kowalski'), ('JNO','Jan','Nowak')

--	Tabela z informacjami o wyp³atach
--	w systemie Ÿród³owym
--------------------------------------------------

	CREATE TABLE src.Payments
	(
		PaymentId	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY
	,	EmpId		VARCHAR(3)		NOT NULL
	,	DateId		DATE			NOT NULL
	,	Amount		FLOAT
	)
	GO

	INSERT INTO [src].[Payments]( [EmpId], [DateId], [Amount] )
	VALUES	
		('AKO','20170101',10000)
	,	('AKO','20170201',10000)
	,	('AKO','20170301',10000)	
	,	('JNO','20170101',20000)
	,	('JNO','20170201',20000)
	,	('JNO','20170301',20000)	
	,	('ABC','20170101',30000)
	,	('ABC','20170201',30000)
	,	('ABC','20170301',30000)