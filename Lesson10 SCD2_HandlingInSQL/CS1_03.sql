USE TestDB
GO

IF OBJECT_ID('dbo.usp_Reload_DWH_DimEmployeeSCD2', 'P') IS NOT NULL DROP PROC [dbo].[usp_Reload_DWH_DimEmployeeSCD2]
GO

CREATE PROC [dbo].[usp_Reload_DWH_DimEmployeeSCD2]
AS
BEGIN
	
	--	Procedura ma aktualizowaæ [dbo].[DWH_DimEmployeeSCD2]
	--	mamy nastêpuj¹ce scenariusze:
	--	1/ pojawia siê nowy pracownik, trzeba go dodaæ
	--	2/ znika pracownik, trzeba go skasowaæ albo wy³¹czyæ
	--	3/ zmieniaj¹ siê dane:
		--	3a/ chcemy mieæ wgl¹d do historii = kolumny [Salary],[BonusRate],[JobPosition],[TeamName]
		--	3b/ nie chcemy mieæ wgl¹du do historii, nadpisujemy dane
				
	----------------------------------------------------------------------------------------------------

		IF OBJECT_ID('tempdb..#Temporary')	IS NOT NULL DROP TABLE	#Temporary
		IF OBJECT_ID('tempdb..#Actions')	IS NOT NULL DROP TABLE	#Actions

	--	Do tabeli tymczasowej zrzucamy aktualny stan systemów Ÿród³owych
	--	jest SCD2 wiêc nie mo¿emy go tak po prostu za³adowaæ/podmieniæ
	----------------------------------------------------------------------------------------------------

		SELECT
			hr.[PESEL]
		,	hr.[EmpFirstName]
		,	hr.[EmpLastName]
		,	hr.[DateOfBirth]
		,	fi.[Salary]
		,	fi.[BonusRate]
		,	og.[JobPosition]
		,	og.[TeamName]
		INTO #Temporary
		FROM
					[dbo].[HR_Employees]	AS hr
		INNER JOIN  [dbo].[FIN_Payroll]		AS fi	ON hr.[PESEL]	= fi.[PESEL]
		INNER JOIN  [dbo].[ORG_Structure]	AS og	ON hr.[PESEL]	= og.[PESEL]


	--	Porównujemy ze sob¹ dwie tabele: aktualny stan systemów Ÿród³owych oraz dane w tabeli wymiaru
	--
	--	je¿eli coœ jest w a nie ma w Ÿrodle, to znaczy, ¿e zwolniony i trzeba wiersz skasowaæ - flaga DELETE
	--	je¿eli coœ jest w Ÿrodle a nie ma w wymiarze, to znaczy, ¿e nowy i trzeba wiersz dodaæ - flaga INSERT
	--	je¿eli coœ jest tu i tu i zmieni³y siê kolumny, których nie chcemy trzymaæ w SCD 2 to robimy zwyk³y UPDATE - flaga UPDATE_NoHistory
	--	je¿eli coœ jest tu i tu i zmieni³a siê jakakolwiek z kolumn, których wartoœæ chcemy trzymaæ w SCD2 to wiersz tzeba wy³¹czyæ (nie kasowaæ!!) i dodaæ nowy - flaga UPDATE_SCD2
	----------------------------------------------------------------------------------------------------

		SELECT
			[PESEL]			=	COALESCE(src.PESEL,tgt.PESEL)
		,	[ActionTime]	=	CAST ( GETDATE() AS DATETIME2(0))
		,	[Action]		=	CASE 
									WHEN	src.PESEL	IS NULL 
									THEN	'DELETE'
									WHEN	tgt.PESEL	IS NULL 
									THEN	'INSERT'
									WHEN	src.PESEL = tgt.PESEL
											AND	(		tgt.[Salary]		=	src.[Salary]
													OR	tgt.[BonusRate]		=	src.[BonusRate]
													OR	tgt.[JobPosition]	=	src.[JobPosition]
													OR	tgt.[TeamName]		=	src.[TeamName]
											)
											AND(		tgt.[EmpFirstName]	<>	src.[EmpFirstName]	
													OR	tgt.[EmpLastName]	<>	src.[EmpLastName]	
													OR	tgt.[DateOfBirth]	<>	src.[DateOfBirth]	
											)
									THEN	'UPDATE_NoHistory'
									WHEN	src.PESEL = tgt.PESEL
											AND	(		tgt.[Salary]		<> src.[Salary]
													OR	tgt.[BonusRate]		<> src.[BonusRate]
													OR	tgt.[JobPosition]	<> src.[JobPosition]
													OR	tgt.[TeamName]		<> src.[TeamName]
											)
									THEN	'UPDATE_SCD2'
									ELSE	'NO ACTION'
									END
		INTO #Actions
		FROM	
						#Temporary					AS src
		FULL OUTER JOIN	[dbo].[DWH_DimEmployeeSCD2]	AS tgt	ON src.PESEL		=	tgt.PESEL
															AND	tgt.IsActive	=	1
		WHERE	1=1
	
		SELECT *
		FROM #Actions

	----------------------------------------------------------------------------------------------------

		--	INSERT NEW ROWS
		--------------------------------------------

			INSERT INTO [dbo].[DWH_DimEmployeeSCD2]
			(
					[PESEL]				
				,	[EmpFirstName]		
				,	[EmpLastName]		
				,	[DateOfBirth]		
				,	[Salary]			
				,	[BonusRate]			
				,	[JobPosition]		
				,	[TeamName]			

				,	[IsActive]			
				,	[BegDateTime]		
				,	[EndDateTime]		
			)
			SELECT
				[PESEL]			=	tmp.[PESEL]
			,	[EmpFirstName]	=	tmp.[EmpFirstName]
			,	[EmpLastName]	=	tmp.[EmpLastName]
			,	[DateOfBirth]	=	tmp.[DateOfBirth]
			,	[Salary]		=	tmp.[Salary]
			,	[BonusRate]		=	tmp.[BonusRate]
			,	[JobPosition]	=	tmp.[JobPosition]
			,	[TeamName]		=	tmp.[TeamName]

			,	[IsActive]			=	1
			,	[BegDateTime]		=	act.ActionTime
			,	[EndDateTime]		=	NULL	
			FROM	
						#Temporary	AS tmp
			INNER JOIN	#Actions	AS act ON tmp.PESEL = act.PESEL
			WHERE
				act.[Action] = 'INSERT'

		--	DELETE OLD ROWS (nie kasujemy a wy³¹czamy)
		--------------------------------------------

			UPDATE trg
			SET
				[IsActive]			=	0
			,	[EndDateTime]		=	DATEADD(s, -1, act.ActionTime)	
			FROM	
						[dbo].[DWH_DimEmployeeSCD2]	AS trg
			INNER JOIN	#Actions					AS act ON trg.PESEL = act.PESEL
			WHERE 1=1
			AND trg.IsActive = 1
			AND act.[Action] = 'DELETE'

		--	UPDATE CHANGES No History
		--------------------------------------------

			UPDATE trg
			SET
				[EmpFirstName]	=	tmp.[EmpFirstName]	
			,	[EmpLastName]	=	tmp.[EmpLastName]	
			,	[DateOfBirth]	=	tmp.[DateOfBirth]	
			FROM	
						[dbo].[DWH_DimEmployeeSCD2]	AS trg
			INNER JOIN	#Actions					AS act ON trg.PESEL = act.PESEL
			INNER JOIN	#Temporary					AS tmp ON tmp.PESEL = act.PESEL
			WHERE 1=1
			AND trg.IsActive = 1
			AND act.[Action] = 'UPDATE_NoHistory'
			;

		--	UPDATE CHANGES SC2
		--------------------------------------------

			UPDATE trg
			SET
				[IsActive]			=	0
			,	[EndDateTime]		=	DATEADD(s, -1, act.ActionTime)	
			FROM	
						[dbo].[DWH_DimEmployeeSCD2]	AS trg
			INNER JOIN	#Actions					AS act ON trg.PESEL = act.PESEL
			WHERE 1=1
			AND trg.IsActive = 1
			AND act.[Action] = 'UPDATE_SCD2'
			;

			INSERT INTO [dbo].[DWH_DimEmployeeSCD2]
			(
					[PESEL]				
				,	[EmpFirstName]		
				,	[EmpLastName]		
				,	[DateOfBirth]		
				,	[Salary]			
				,	[BonusRate]			
				,	[JobPosition]		
				,	[TeamName]			

				,	[IsActive]			
				,	[BegDateTime]		
				,	[EndDateTime]		
			)
			SELECT
				[PESEL]			=	tmp.[PESEL]
			,	[EmpFirstName]	=	tmp.[EmpFirstName]
			,	[EmpLastName]	=	tmp.[EmpLastName]
			,	[DateOfBirth]	=	tmp.[DateOfBirth]
			,	[Salary]		=	tmp.[Salary]
			,	[BonusRate]		=	tmp.[BonusRate]
			,	[JobPosition]	=	tmp.[JobPosition]
			,	[TeamName]		=	tmp.[TeamName]

			,	[IsActive]			=	1
			,	[BegDateTime]		=	act.ActionTime
			,	[EndDateTime]		=	NULL	
			FROM	
						#Temporary	AS tmp
			INNER JOIN	#Actions	AS act ON tmp.PESEL = act.PESEL
			WHERE
				act.[Action] = 'UPDATE_SCD2'

END