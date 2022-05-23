USE [ProyectoBD]
GO

/****** Object:  Table [dbo].[Puesto]    Script Date: 5/19/2022 4:35:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DECLARE @xmlData XML

SET @xmlData = (
		SELECT *
		FROM OPENROWSET(BULK 'C:\Users\eastorga\Documents\GitHub\-Tarea-Programada-BD-2-3\Datos_Tarea3.xml', SINGLE_BLOB) 
		AS xmlData
		);

DECLARE @Fechas TABLE (ID INT IDENTITY (1, 1), fechaOperacion DATE)

DECLARE @EmpleadosInsertar TABLE (ID INT IDENTITY(1,1),FechaNacimiento DATE, Nombre VARCHAR(128), Passwrd VARCHAR(128),
		UserName VARCHAR(128),valorDocuIdent INT, IdDepartamento INT, IdPuesto INT, IdTipoDocu INT)

DECLARE @EmpleadosBorrar TABLE (ID INT IDENTITY(1,1),ValorDocuId INT)

DECLARE @InsertarDeducciones TABLE (ID INT IDENTITY(1,1),IdTipoDec INT, Monto MONEY, valorDocuIdent INT)

DECLARE @EliminarDeducciones TABLE (ID INT IDENTITY(1,1),IdTipoDec INT, valorDocuIdent INT)

DECLARE @asistencias TABLE (ID INT IDENTITY(1,1), ValorDocIdentidad VARCHAR(64), Entrada DATETIME, Salida DATETIME)

DECLARE @NuevosHorarios TABLE (ID INT IDENTITY(1,1), IdJornada INT, ValorDocIdentidad INT)

DECLARE @lo INT
DECLARE @hi INT
DECLARE @Entrada TIME
DECLARE @Salida TIME
DECLARE @ValorDocIdentidad INT
DECLARE @idempleado INT
DECLARE @HoraInicioJ TIME
DECLARE @HoraFinJ TIME
DECLARE @Jornada INT
DECLARE @horasOrdinarias INT
DECLARE @horasDobles INT
DECLARE @montoGanadoHO MONEY
DECLARE @montoGanadoHD MONEY
DECLARE @montoGanadoHE MONEY
DECLARE @EntradaOP TIME
DECLARE @SalidaOP TIME
DECLARE @SalarioXHora INT
DECLARE @Dobles BIT = 0
DECLARE @EsJueves BIT
DECLARE @EsFinMes BIT

INSERT @Fechas (FechaOperacion)
SELECT T.Item.value('@Fecha', 'DATE')
FROM @xmlData.nodes('Datos/Operacion') as T(Item)

DECLARE @FechaItera DATE, @FechaFin DATE
SELECT @FechaItera=MIN(fechaOperacion), @FechaFin=MAX(fechaOperacion)
FROM @Fechas

INSERT dbo.Jornada (IdTipoJornada)
SELECT 1
INSERT dbo.Jornada (IdTipoJornada)
SELECT 2
INSERT dbo.Jornada (IdTipoJornada)
SELECT 3


--


WHILE (@FechaItera<=@FechaFin)
BEGIN
	INSERT @EmpleadosInsertar (FechaNacimiento, Nombre, Passwrd, UserName, valorDocuIdent, IdDepartamento, IdPuesto, IdTipoDocu)
	SELECT 
		T.Item.value('@FechaNacimiento', 'DATE'),
		T.Item.value('@Nombre', 'VARCHAR(128)'),
		T.Item.value('@Passowrd', 'VARCHAR(128)'),
		T.Item.value('@Username', 'VARCHAR(128)'),
		T.Item.value('@ValorDocumentoIdentidad', 'INT'),
		T.Item.value('@idDepartamento', 'INT'),
		T.Item.value('@idPuesto', 'INT'),
		T.Item.value('@idTipoDocumentacionIdentidad', 'INT')
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/NuevoEmpleado') as T(Item)
	
	INSERT @EmpleadosBorrar (ValorDocuId)
	SELECT 
		T.Item.value('@ValorDocumentoIdentidad', 'INT')
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/EliminarEmpleado') as T(Item)
	
	INSERT @InsertarDeducciones (IdTipoDec, Monto, valorDocuIdent)
	SELECT 
		T.Item.value('@IdDeduccion', 'INT'),
		T.Item.value('@Monto', 'MONEY'),
		T.Item.value('@ValorDocumentoIdentidad', 'INT')
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/AsociaEmpleadoConDeduccion') as T(Item)
	
	INSERT @EliminarDeducciones (ID, valorDocuIdent)
	SELECT 
		T.Item.value('@IdDeduccion', 'INT'),
		T.Item.value('@ValorDocumentoIdentidad', 'INT')
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/DesasociaEmpleadoConDeduccion') as T(Item)

	INSERT @asistencias (ValorDocIdentidad, Entrada, Salida)
	SELECT 
		T.Item.value('@FechaEntrada', 'DATETIME'),
		T.Item.value('@FechaSalida', 'DATETIME'),
		T.Item.value('@ValorDocumentoIdentidad', 'INT')
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/MarcaDeAsistencia') as T(Item)
	
	INSERT @NuevosHorarios (IdJornada, ValorDocIdentidad)
	SELECT
		T.Item.value('@IdJornada', 'INT'),
		T.Item.value('@ValorDocumentoIdentidad', 'INT')
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/TipoDeJornadaProximaSemana') as T(Item)
	
	IF @xmlData.exist('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/NuevoEmpleado') = 1
	BEGIN

		INSERT dbo.Obrero(Nombre, IdTipoDocIdentidad, ValorDocIdentidad, IdPuesto,FechaNacimiento,IdDepartamento,IdJornada)
		SELECT E.Nombre, E.IdTipoDocu, E.valorDocuIdent, E.IdPuesto, E.FechaNacimiento,E.IdDepartamento,1
		FROM @EmpleadosInsertar E

		INSERT dbo.PlanillaMesXEmpleado (FechaInicio,FechaFinal,SalarioNeto,SalarioTotal,TotalDeducciones,IdObrero)
		SELECT
			@FechaItera,
			EOMONTH(@FechaItera),
			0,
			0,
			0,
			O.Id
			FROM @EmpleadosInsertar EI
			INNER JOIN dbo.Obrero O ON EI.valorDocuIdent=O.ValorDocIdentidad
		
		INSERT INTO dbo.PlanillaSemanaXEmpleado (FechaInicio,FechaFinal,SalarioNeto,SalarioTotal,TotalDeducciones,IdObrero,IdMes,IdJornada)
		VALUES(
			(@FechaItera),
			(EOMONTH(@FechaItera)),
			(0),
			(0),
			(0),
			(SELECT O.ID
			FROM @EmpleadosInsertar EI
			INNER JOIN dbo.Obrero O ON EI.valorDocuIdent=O.ValorDocIdentidad),
			(SELECT M.ID
			FROM dbo.PlanillaMesXEmpleado M
			WHERE (@FechaItera BETWEEN M.FechaInicio and M.FechaFinal)),
			(SELECT O.IdJornada
			FROM @EmpleadosInsertar EI
			INNER JOIN dbo.Obrero O ON EI.valorDocuIdent=O.ValorDocIdentidad)
			)
	END
	-- el mapeo entre usuarios y empleado, al insertar usuarios sera por ValorDocIdentidad
	INSERT dbo.Usuarios (UserName, Password, EsAdmin, IdObrero)
	SELECT EXML.UserName, EXML.Passwrd, 0, O.Id
	FROM @EmpleadosInsertar EXML
	INNER JOIN dbo.Obrero O ON EXML.valorDocuIdent=O.ValorDocIdentidad

	IF @xmlData.exist('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/AsociaEmpleadoConDeduccion') = 1
	BEGIN
	
	-- Insertar deduccion no obligatorias
    INSERT dbo.Deducciones (IdObrero,IdTipoDeduccion,Monto,Fecha)
	SELECT O.Id, D.IdTipoDec, D.Monto, @FechaItera
	FROM @InsertarDeducciones D
	INNER JOIN dbo.Obrero O ON D.valorDocuIdent=O.ValorDocIdentidad
	END
	
	-- desasociar (eliminar deducciones) ...

	IF @xmlData.exist('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/DesasociaEmpleadoConDeduccion') = 1
	BEGIN

		UPDATE dbo.Deducciones
		SET Activa = 1
		FROM @EliminarDeducciones E
		INNER JOIN dbo.Deducciones D ON E.IdTipoDec = D.IdTipoDeduccion
		INNER JOIN dbo.Obrero O ON E.valorDocuIdent = O.ValorDocIdentidad
		WHERE (O.ValorDocIdentidad = E.valorDocuIdent) AND (D.IdObrero = O.ID)

	END
		
	-- Procesar asistencias

	IF @xmlData.exist('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/MarcaDeAsistencia') = 1
	BEGIN

		SELECT @lo=Min(A.ID), @hi=Max(A.ID)
		FROM @asistencias A
	
		WHILE (@lo<=@hi)
		BEGIN
			SELECT @Entrada=A.Entrada, @Salida=A.Salida, @ValorDocIdentidad=A.ValorDocIdentidad
			FROM @asistencias A
			WHERE A.ID=@lo;
		
			SELECT @idempleado=E.Id, @Jornada=E.IdJornada
			FROM dbo.Obrero E
			WHERE E.ValorDocIdentidad=@ValorDocIdentidad

			SELECT @SalarioXHora = P.SalarioXHora
			FROM dbo.Puesto P
			INNER JOIN dbo.Obrero O ON P.ID = O.IdPuesto
			WHERE @idempleado = O.ID
		
			-- Determinar horas ordinarias
				-- determinar la jornada de esta semana de ese empleado
				SELECT @HoraInicioJ=TJ.HoraEntrada, @HoraFinJ=TJ.HoraSalida
				FROM dbo.TipoJornada TJ
				INNER JOIN dbo.Jornada J on TJ.ID=J.IdTipoJornada
				WHERE (J.ID = @Jornada)
			
				-- determinar horas ordinarias
				IF @Entrada>@HoraInicioJ
				BEGIN
					SET @EntradaOP = @Entrada;
				END

				ELSE
				BEGIN
					SET @EntradaOP = @HoraInicioJ;
				END

				IF @Salida>@HoraFinJ
				BEGIN
					SET @SalidaOP = @HoraFinJ;
					SET @Dobles = 1;
				END

				ELSE
				BEGIN
					SET @SalidaOP = @Salida;
				END

				SET @horasOrdinarias = (DATEDIFF(MI,@EntradaOP, @SalidaOP))/60;
						
				SET @montoGanadoHO = @horasOrdinarias*@SalarioXHora
			
				IF @Dobles=1
				BEGIN
					IF (EXISTS(SELECT F.FECHA FROM FERIADOS F WHERE F.Fecha=@FechaItera)) OR (DATENAME(WEEKDAY,@FechaItera)='Sunday')
					BEGIN

					SET @horasDobles = (DATEDIFF(MI,@HoraFinJ, @Salida))/60;
				
					--- determinar horas extraordinarias dobles  y monto
					SET @montoGanadoHD = (@horasDobles*@SalarioXHora)*2;
								
				END 
				ELSE 
				BEGIN
					--- determinar horas extraordinarias normales y moto
					SET @montoGanadoHE = (@horasDobles*@SalarioXHora)*1.5;
							
				END
			
				SET @EsJueves = 0
				IF (DATENAME(WEEKDAY,@FechaItera)='Thursday')
				BEGIN
				  SET @EsJueves = 1
			  
					
			  
				  -- calcular deducciones no obligatorias

				END
			
				SET @EsFinMes=0
				IF (@FechaItera = EOMONTH(@FechaItera))
				BEGIN
				   SET @EsFinMes=1
				END
			
				BEGIN TRANSACTION
					INSERT dbo.MarcasDeAsistencia(ValorTipoDocu,FechaEntrada,FechaSalida,IdJornada)
					SELECT @ValorDocIdentidad,@Entrada,@Salida,O.IdJornada
					FROM dbo.Obrero O
					WHERE @ValorDocIdentidad = O.ValorDocIdentidad
				
					IF @montoGanadoHo>0
					BEGIN
						INSERT dbo.MovimientoCredito (Fecha,Monto,IdAsistencia,IdTipoMov,Horas)
						SELECT @FechaItera, @montoGanadoHO, MAX(A.ID),1,@horasOrdinarias
						FROM dbo.MarcasDeAsistencia A
					END
				
					IF @montoGanadoHD>0
					BEGIN
						INSERT dbo.MovimientoCredito (Fecha,Monto,IdAsistencia,IdTipoMov,Horas)
						SELECT @FechaItera, @montoGanadoHD, MAX(A.ID),3,@horasDobles
						FROM dbo.MarcasDeAsistencia A
					END
				
					IF @montoGanadoHE>0
					BEGIN
						INSERT dbo.MovimientoCredito (Fecha,Monto,IdAsistencia,IdTipoMov,Horas)
						SELECT @FechaItera, @montoGanadoHE, MAX(A.ID),2,@horasDobles
						FROM dbo.MarcasDeAsistencia A
					END
				
					IF @EsJueves = 1
					BEGIN
						-- insertar movimientos de deduccion
						-- Cear instancia en semanaplanilla
						-- actualizar planillaxmesxemp
					END
				
					If @EsFinMes = 1
					BEGIN
						-- crear instancia de PlanillaxMesxEmp
					END
				
					UPDATE dbo.PlanillaSemanaXEmpleado
					SET SalarioTotal=SalarioTotal + @montoGanadoHO+@montoGanadoHE+@montoGanadoHD
					WHERE IdObrero=@idEmpleado and @FechaItera BETWEEN FechaInicio and FechaFinal
			
				COMMIT TRANSACTION
		END
	END



END