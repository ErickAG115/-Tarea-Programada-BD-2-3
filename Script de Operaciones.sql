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
DECLARE @EmpleadosInsertar TABLE (FechaNacimiento DATE, Nombre VARCHAR(128), Passwrd VARCHAR(128), UserName VARCHAR(128), valorDocuIdent INT, IdDepartamento INT, IdPuesto INT, IdTipoDocu INT)
DECLARE @EmpleadosBorrar TABLE (FechaNacimiento DATE, Nombre VARCHAR(128), Passwrd VARCHAR(128), UserName VARCHAR(128), valorDocuIdent INT, IdDepartamento INT, IdPuesto INT, IdTipoDocu INT)
DECLARE @InsertarDeducciones TABLE (ID INT, Monto MONEY, valorDocuIdent INT)
DECLARE @EliminarDeducciones TABLE (ID INT, Monto MONEY, valorDocuIdent INT)
DECLARE @asistencias TABLE (ID INT IDENTITY(1,1), ValorDocIdentidad VARCHAR(64), Entrada DATETIME, Salida DATETIME)
DECLARE @NuevosHorarios TABLE (IdJornada INT, ValorDocIdentidad VARCHAR(64))
DECLARE @hi DATETIME

SELECT @hi=Min(Entrada)
from @asistencias


INSERT @Fechas (FechaOperacion)
SELECT T.Item.value('@Fecha', 'DATE')
FROM @xmlData.nodes('Datos/Operacion') as T(Item)

DECLARE @FechaItera DATE, @FechaFin DATE
SELECT @FechaItera=MIN(fechaOperacion), @FechaFin=MAX(fechaOperacion)
FROM @Fechas


--IF @xmlData.exist('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/MarcaDeAsistencia') = 1


--WHILE (@FechaItera<=@FechaFin)
--BEGIN

   

	-- cargo en tablas variables la info del xml para esta fecha
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
	
	INSERT @EmpleadosBorrar (FechaNacimiento, Nombre, Passwrd, UserName, valorDocuIdent, IdDepartamento, IdPuesto, IdTipoDocu)
	SELECT 
		T.Item.value('@FechaNacimiento', 'DATE'),
		T.Item.value('@Nombre', 'VARCHAR(128)'),
		T.Item.value('@Passowrd', 'VARCHAR(128)'),
		T.Item.value('@Username', 'VARCHAR(128)'),
		T.Item.value('@ValorDocumentoIdentidad', 'INT'),
		T.Item.value('@idDepartamento', 'INT'),
		T.Item.value('@idPuesto', 'INT'),
		T.Item.value('@idTipoDocumentacionIdentidad', 'INT')
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/EliminarEmpleado') as T(Item)
	
	INSERT @InsertarDeducciones (ID, Monto, valorDocuIdent)
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

	INSERT @asistencias (ValorDocIdentidad, Entrada, Salida)
	SELECT 
		T.Item.value('@FechaEntrada', 'DATETIME'),
		T.Item.value('@FechaSalida', 'DATETIME'),
		T.Item.value('@ValorDocumentoIdentidad', 'INT')
	FROM @xmlData.nodes('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/MarcaDeAsistencia') as T(Item)
	
	insert @NuevosHorarios
	
	-- Aplicamos los cargado en tablas variable a la BD real
	-- segun la entidad se puede hacer iterando o utilizando SQL masivo.

	--IF @xmlData.exist('Datos/Operacion[@Fecha = sql:variable("@FechaItera")]/MarcaDeAsistencia') = 1 fui yo
	
	Insert dbo.Empleado (Nombre, IdTipoDocIdentidad, ValorDocumentoIdentidad, ...)
	Select E.Nombre, E.IdTipoDocIdentidad, E.ValorDocumentoIdentidad, ..
	From @EmpleadosInsertar
	
	-- el mapeo entre usuarios y empleado, al insertar usuarios sera por ValorDocIdentidad
	
	INSERT dbo.Usuarios (UserName, Password, EsAdministrador, IdEmpleado)
	SELECT E.UserName, E.Password, 0, E.Id
	FROM @EmpleadosInsertar EXML
	INNER JOIN dbo.Empleado E ON EXML.ValorDocumentoIdentidad=E.ValorDocIdentidad
	
	-- Insertar deduccion no obligatorias
    INSERT dbo.DeduccionesXEmpleado (..)
	Select 
	from @InsertarDeducciones
	
	-- desasociar (eliminar deducciones) ...
	
	UPDATE ....
	
	-- Procesar asistencias
	
	Select @lo=Min(A.Sec), @hi=Max(A.Sec)
	from @asistencias A
	
	WHILE (@lo<=@hi)
	BEGIN
		SELECT @Entrada=A.Entrada, @Salida=A.Salida, @ValorDocIdentidad=A.ValorDocIdentidad
		FROM @Asistencias
		WHERE A.Sec=@lo;
		
		Select @idempleado=E.Id
		from dbo.Empleado E
		Where E.ValorDocIdentidad=@ValorDocIdentidad
		
		-- Determinar horas ordinarias
			-- determinar la jornada de esta semana de ese empleado
			Select @HoraInicioJornada=TJ.HoraInicio, @HoraFinJornada=TJ.HoraFin
			FROM dbo.SemanaPlanilla S
			INNER JOIN dbo.Jornada J on S.Id=J.IdSemana 
			INNER JOIN dbo.TipoJornada TJ H.IdTipoJornada=TJ.I
			WHERE (J.IdEmpleado=@idempleado) and (@FechaItera between S.FechaInicio and S.FechaFin)
			
			-- determinar horas ordinarias
			Set @horasOrdinarias = ????
			
			-- determinar monto ganado por horas ordinarias
			
			Set @montoGanadoHO = @horasOrdinarias*Puesto.SalarioxHOra de ese empleado
			
			IF @fechaItera es feriado o domingo
			begin
				
				--- determinar horas extraordinarias dobles  y monto
				@montoGanadoHO @horasOrdinarias*Puesto.SalarioxHOra de ese empleado * 2
				
				@horasExtraOrdinariasDobles = ???
				
			end else begin
				--- determinar horas extraordinarias normales y moto
				@montoGanadoHO @horasOrdinarias*Puesto.SalarioxHOra de ese empleado * 1. 5
				
				@horasExtraOrdinariasNormales = ???
			
			end;
			
			Set @EsJueves = 0
			If fechaitera es jueves
			begin
			  Set @EsJueves = 1
			  
			  -- calcular deduccionesObligatorias
			  
			  -- calcular deducciones no obligatorias

			end
			
			Set @EsFinMes=0
			If FechaItera es fin de mes
			Begin
			   Set @EsFinMes=1
			end
			
			
			.... la transaccion siempre sera lo ultimo respecto del proceso de un empleado
			Begin transation
			    insertar asistencias 
				...
				
				insertar movimientoplanilla ()
				select .... @montoGanadoHO ...
				where  @horasOrdinarias>0
				
				insertar movimientoplanilla ()
				select .... @montoGanadoHExtrasNormal ...
				where  @horasExtraOrdinariasNOrmales>0
				
				insertar movimientoplanilla ()
				select .... @montoGanadoHExtrasDobles ...
				where  @horasExtraOrdinariasDobles>0
				
				if @esJueves
				Begin
					-- insertar movimientos de deduccion
					-- Cear instancia en semanaplanilla
					-- actualizar planillaxmesxemp
				end
				
				If #esfin de mes
				begin
				    -- crear instancia de PlanillaxMesxEmp
				end
				
				Update dbo.PlanillaSemanalXEmp
				set SalarioBruto=@montoGanadoHO+@montoGanadoHExtrasNormal+@horasExtraOrdinariasDobles
				where EdEmpleado=@idEmpleado and IdSemama=@IdSemana	
			
			commit transaction
	END
end;