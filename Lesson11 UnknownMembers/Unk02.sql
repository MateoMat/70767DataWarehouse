USE [TestDB]
GO

--	Tabela wymiaru pracownika w HURTOWNI
--------------------------------------------------

	--	w systemach docelowych istniej¹ ju¿ klucze g³ówne tabel
	--	ale zgodnie z dobrymi praktykami nie bêdziemy ich u¿ywaæ jako PK w hurtownii
	--	dodajemy klucze surogatowe (techniczne) które nie nios¹ informacji biznesowej
	--	klucz g³ówny z tabeli Ÿród³owej jest kopiowany, ale ju¿ jako atrybut (EmpId)
	--	mo¿emy dodaæ constraint UNIQUE, ale nie musimy

	CREATE TABLE dest.DimEmployee
	(
		DimEmployeeKey	INT				NOT NULL	IDENTITY(1,1) PRIMARY KEY
	,	EmpId			VARCHAR(3)		NOT NULL	UNIQUE
	,	EmpFirstName	VARCHAR(100)	NOT NULL
	,	EmpLastName		VARCHAR(100)	NOT NULL
	)
	GO


--	Tabela faktów w HURTOWNI
--------------------------------------------------
	
	--	podobnie jak wy¿ej, dodajemy nowy klucz (FactPaymentKey)
	--	dodatkowo bêdziemy chcieli utwórzyæ FK pomiêdzy tabel¹ Faktów i Wymiarem pracownika
	--	kolumn¹ do ³¹czenia bêdzie (DimEmployeeKey)
	--	kolumna EmpId przestaje nam byæ potrzebna (dublowanie danych)
	--	maj¹d DimEmployeeKey bêdziemy mogli j¹ doci¹gn¹æ zawsze z wymiau - wiêc pomijamy

	CREATE TABLE dest.FactPayment
	(
		FactPaymentKey	INT				NOT NULL	IDENTITY(1,1) PRIMARY KEY 
	,	PaymentId		INT				NOT NULL	UNIQUE
	,	DimEmployeeKey	INT				
	,	DateId			DATE			
	,	Amount			FLOAT
	)
	GO
