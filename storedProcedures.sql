use [ProyectoBD];

--------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS [dbo].[filtrarNombre];

CREATE PROCEDURE [dbo].[filtrarNombre]
	AS BEGIN
		SELECT [Puesto].[ID],[Puesto].[NombreP],[Puesto].[SalarioXHora] FROM [dbo].[Puesto] WHERE [Puesto].[Borrado] = 1 ORDER BY [Puesto].[NombreP] ;           
	END
GO
EXEC filtrarNombre
--------------------------------------------------------------------------------------


DROP PROCEDURE IF EXISTS [dbo].[insertarPuesto];

CREATE PROCEDURE [dbo].[insertarPuesto] @inNombre NVARCHAR(128), @inSalario INT
	AS BEGIN
		INSERT INTO [dbo].[Puesto] ([NombreP], [SalarioXHora]) VALUES	(@inNombre,@inSalario);
	END
GO

EXEC insertarPuesto @inNombre = 'Seguridad', @inSalario = 1520
--------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS [dbo].[editarPuesto];

CREATE PROCEDURE [dbo].[editarPuesto] @inId INT, @inNombre NVARCHAR(128), @inSalario INT
	AS BEGIN
		UPDATE [dbo].[Puesto] SET [Puesto].[NombreP] = @inNombre,[Puesto].[SalarioXHora] = @inSalario WHERE [Puesto].[ID] = @inId;
	END
GO

EXEC [dbo].[editarPuesto] @inId = 1, @inNombre = 'yooooo', @inSalario = 1234;
--------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS [dbo].[listarEmpleados];

CREATE PROCEDURE [dbo].[listarEmpleados]
	AS BEGIN
		SELECT [Obrero].[ID], [Obrero].[Nombre], [Puesto].[NombreP], [TipoDocIdentidad].[NombreTip],[Obrero].[ValorDocIdentidad], [Obrero].[FechaNacimiento], [Departamentos].[NombreDep]  
		FROM [dbo].[Obrero] INNER JOIN [dbo].[Puesto] ON [Obrero].[Puesto] = [Puesto].[NombreP] INNER JOIN [dbo].[TipoDocIdentidad] ON [Obrero].[IdTipoDocIdentidad] = [TipoDocIdentidad].[ID] 
		INNER JOIN [dbo].[Departamentos] ON [Obrero].[IdDepartamento] = [Departamentos].[ID]
		WHERE [Obrero].[Borrado] = 1  ORDER BY [Puesto].[NombreP];           
	END
GO
EXEC [listarEmpleados]

-------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS [dbo].[insertarEmpleado];

CREATE PROCEDURE [dbo].[insertarEmpleado] @inNombre NVARCHAR(128), @inIdTipoDocIdentidad INT, @inValorDocIdentidad INT, @inPuesto NVARCHAR(128), @inFechaNacimiento NVARCHAR(128), @inIdDepartamento INT
	AS BEGIN
		INSERT INTO [dbo].[Obrero] ([Nombre], [idTipoDocIdentidad],[ValorDocIdentidad], [Puesto],[FechaNacimiento], [IdDepartamento]) VALUES	(@inNombre,@inIdTipoDocIdentidad, @inValorDocIdentidad, @inPuesto, CAST(@inFechaNacimiento as date), @inIdDepartamento);
	END
GO

EXEC [insertarEmpleado]

EXEC [dbo].[insertarEmpleado] @inNombre = 'Ken', @inIdTipoDocIdentidad = 1, @inValorDocIdentidad = 1122, @inPuesto = 'Guardia', @inFechaNacimiento = '20001204', @inIdDepartamento = 1

---------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS  [dbo].[listarEmpleadosFiltro];

CREATE PROCEDURE  [dbo].[listarEmpleadosFiltro] @inNombre NVARCHAR(128)
	AS BEGIN

		IF (@inNombre = '') -- excepcion forzada del programador
			SELECT [Obrero].[ID], [Obrero].[Nombre], [Puesto].[NombreP], [TipoDocIdentidad].[NombreTip],[Obrero].[ValorDocIdentidad], [Obrero].[FechaNacimiento], [Departamentos].[NombreDep]  
			FROM [dbo].[Obrero] INNER JOIN [dbo].[Puesto] ON [Obrero].[Puesto] = [Puesto].[NombreP] INNER JOIN [dbo].[TipoDocIdentidad] ON [Obrero].[IdTipoDocIdentidad] = [TipoDocIdentidad].[ID] 
			INNER JOIN [dbo].[Departamentos] ON [Obrero].[IdDepartamento] = [Departamentos].[ID]
			WHERE [Obrero].[Borrado] = 1  ORDER BY [Puesto].[NombreP];             
		ELSE
			SELECT [Obrero].[ID], [Obrero].[Nombre], [Puesto].[NombreP], [TipoDocIdentidad].[NombreTip],[Obrero].[ValorDocIdentidad], [Obrero].[FechaNacimiento], [Departamentos].[NombreDep]  
			FROM [dbo].[Obrero] INNER JOIN [dbo].[Puesto] ON [Obrero].[Puesto] = [Puesto].[NombreP] INNER JOIN [dbo].[TipoDocIdentidad] ON [Obrero].[IdTipoDocIdentidad] = [TipoDocIdentidad].[ID] 
			INNER JOIN [dbo].[Departamentos] ON [Obrero].[IdDepartamento] = [Departamentos].[ID] 
			WHERE [Obrero].[Borrado] = 1 AND [Obrero].[Nombre]  LIKE '%'+@inNombre+'%' ORDER BY [Puesto].[NombreP] ;

		END
GO

------------------------------------------------------
DROP PROCEDURE IF EXISTS [dbo].[editarEmpleado];

CREATE PROCEDURE [dbo].[editarEmpleado] @inId INT, @inNombre NVARCHAR(128), @inTipoDocIdentidad INT, @inValorDocIdentidad INT, @inFechaNacimiento NVARCHAR(128), @inIdDepartamento INT, @inPuesto NVARCHAR(128)
	AS BEGIN
		UPDATE [dbo].[Obrero] SET [Obrero].[Nombre] = @inNombre, [Obrero].[IdTipoDocIdentidad] = @inTipoDocIdentidad, [Obrero].[ValorDocIdentidad] = @inValorDocIdentidad, 
		[Obrero].[FechaNacimiento] = CAST(@inFechaNacimiento AS DATE), [Obrero].[IdDepartamento] = @inIdDepartamento, [Obrero].[Puesto] = @inPuesto WHERE [Obrero].[ID] = @inId;
	END
GO



------------------------------------------------------

DROP PROCEDURE IF EXISTS [dbo].[borrarEmpleado];

CREATE PROCEDURE [dbo].[borrarEmpleado] @inId INT
	AS BEGIN
		UPDATE [dbo].[Obrero] SET [Obrero].[Borrado] = 0 WHERE [Obrero].[ID] = @inId;
	END
GO

DROP PROCEDURE IF EXISTS [dbo].[borrarPuesto]

CREATE PROCEDURE [dbo].[borrarPuesto] @inId INT
	AS BEGIN
		UPDATE [dbo].[Puesto] SET [Puesto].[Borrado] = 0 WHERE [Puesto].[ID] = @inId;
	END
GO

DROP PROCEDURE IF EXISTS [dbo].[retornarUsers];

CREATE PROCEDURE [dbo].[retornarUsers]
	AS BEGIN
		SELECT [Usuarios].[Nombre],[Usuarios].[Password] FROM [dbo].[Usuarios];
	END
GO

CREATE PROCEDURE [dbo].[retornarPuestos]
	AS BEGIN
		SELECT [Puesto].[NombreP] FROM [dbo].[Puesto];
	END
GO
-------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------Nuevos Stored procedures--------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS [dbo].[PlanillasSemanales];

CREATE PROCEDURE [dbo].[PlanillasSemanales] @inIdUsuario INT

	AS BEGIN
		SET NOCOUNT ON;
		
			SELECT [TipoMovimiento].[Nombre] as 'TipoJornada',
			[PlanillaSemanaXEmpleado].[SalarioTotal],
			[PlanillaSemanaXEmpleado].[TotalDeducciones], 
			[PlanillaSemanaXEmpleado].[SalarioNeto],
			[MovimientoCredito].[Horas]
			FROM [dbo].[Usuarios] 
			INNER JOIN [dbo].[Obrero] ON [Obrero].[ID] = [Usuarios].[IdObrero]
			INNER JOIN [dbo].[Jornada] ON [Jornada].[ID] = [Obrero].[IdJornada]
			INNER JOIN [dbo].[PlanillaSemanaXEmpleado] ON [PlanillaSemanaXEmpleado].[IdObrero] = [Obrero].[ID]
			INNER JOIN [dbo].[MarcasDeAsistencia] ON [MarcasDeAsistencia].[IdJornada] = [Jornada].[ID]
			INNER JOIN [dbo].[MovimientoCredito] ON [MovimientoCredito].[IdAsistencia] = [MarcasDeAsistencia].[ID]
			INNER JOIN [dbo].[TipoMovimiento] ON [TipoMovimiento].[ID] = [MovimientoCredito].[IdTipoMov]
			WHERE @inIdUsuario = [Usuarios].[ID] 
			GROUP BY [TipoMovimiento].[Nombre]
			SET NOCOUNT OFF;
	END
GO

-------------------------------------------------------------------------------------------------------------------------------


DROP PROCEDURE IF EXISTS [dbo].[DeduccionesMontoSemana];

CREATE PROCEDURE [dbo].[DeduccionesMontoSemana] @inIdUsuario INT

	AS BEGIN
		SET NOCOUNT ON;
		
			SELECT [TipoDeduccion].[Nombre],
			[TipoDeduccion].[Porcentual],
			[Deducciones].[Monto]
			FROM [dbo].[Usuarios] 
			INNER JOIN [dbo].[Obrero] ON [Obrero].[ID] = [Usuarios].[IdObrero]
			INNER JOIN [dbo].[Deducciones] ON [Deducciones].[IdObrero] = [Obrero].[ID]
			INNER JOIN [dbo].[TipoDeduccion] ON [TipoDeduccion].[ID] = [Deducciones].[IdTipoDeduccion]
			WHERE @inIdUsuario = [Usuarios].[ID];
		SET NOCOUNT OFF;
	END
GO

EXEC [DeduccionesMontoSemana] @inIdUsuario = 1

-------------------------------------------------------------------------------------------------------------------------------


DROP PROCEDURE IF EXISTS [dbo].[DeduccionesMonto];

CREATE PROCEDURE [dbo].[HorasMontos] @inIdUsuario INT, @inFechaInicio datetime, @inFechaFin datetime

	AS BEGIN
		SET NOCOUNT ON;
			SELECT [TipoMovimiento].[Nombre],
			[MovimientoCredito].[Monto]
			FROM [dbo].[Usuarios]
			INNER JOIN [dbo].[Obrero] ON [Obrero].[ID] = [Usuarios].[IdObrero]
			INNER JOIN [dbo].[Jornada] ON [Jornada].[ID] = [Obrero].[IdJornada]
			INNER JOIN [dbo].[MarcasDeAsistencia] ON [MarcasDeAsistencia].[IdJornada] = [Jornada].[ID]
			INNER JOIN [dbo].[MovimientoCredito] ON [MovimientoCredito].[IdAsistencia] = [MarcasDeAsistencia].[ID]
			INNER JOIN [dbo].[TipoMovimiento] ON [TipoMovimiento].[ID] = [MovimientoCredito].[IdTipoMov]
			WHERE @inIdUsuario = [Usuarios].[ID] AND 
			[MovimientoCredito].[Fecha] BETWEEN @inFechaInicio AND @inFechaFin
			ORDER BY [TipoMovimiento].[Nombre];
		SET NOCOUNT OFF;
	END
GO

EXEC [HorasMontos] @inIdUsuario = 1, @inFechaInicio = '1968-10-23 12:45:37', @inFechaFin = '2025-10-23 12:45:37'



-------------------------------------------------------------------------------------------------------------------------------

------DROP PROCEDURE [dbo].[SalariosAnuales]

CREATE PROCEDURE [dbo].[SalariosAnuales] @inIdUsuario INT

	AS BEGIN
		SET NOCOUNT ON;
			SELECT [PlanillaMesXEmpleado].[SalarioTotal],
			[PlanillaMesXEmpleado].[TotalDeducciones], 
			[PlanillaMesXEmpleado].[SalarioNeto]
			FROM [dbo].[Usuarios] 
			INNER JOIN [dbo].[Obrero] ON [Obrero].[ID] = [Usuarios].[IdObrero]
			INNER JOIN [dbo].[PlanillaMesXEmpleado] ON [PlanillaMesXEmpleado].[IdObrero] = [Obrero].[ID]
			WHERE @inIdUsuario = [Usuarios].[ID] AND 
			[PlanillaMesXEmpleado].[FechaInicio] between DATEADD(mm, -12, GETDATE())  and getdate()
		SET NOCOUNT OFF;
	END
GO

EXEC [SalariosAnuales] @inIdUsuario = 1


-------------------------------------------------------------------------------------------------------------------------------


DROP PROCEDURE IF EXISTS [dbo].[DeduccionesMontoMes];

CREATE PROCEDURE [dbo].[DeduccionesMontoMes] @inIdUsuario INT

	AS BEGIN
		SET NOCOUNT ON;
		
			SELECT [TipoDeduccion].[Nombre],
			[TipoDeduccion].[Porcentual],
			[Deducciones].[Monto]
			FROM [dbo].[Usuarios] 
			INNER JOIN [dbo].[Obrero] ON [Obrero].[ID] = [Usuarios].[IdObrero]
			INNER JOIN [dbo].[PlanillaMesXEmpleado] ON [PlanillaMesXEmpleado].[IdObrero] = [Obrero].[ID]
			INNER JOIN [dbo].[Deducciones] ON [Deducciones].[IdObrero] = [Obrero].[ID]
			INNER JOIN [dbo].[TipoDeduccion] ON [TipoDeduccion].[ID] = [Deducciones].[IdTipoDeduccion]
			WHERE @inIdUsuario = [Usuarios].[ID] AND
			[PlanillaMesXEmpleado].[FechaInicio] between DATEADD(MONTH, -1, GETDATE())  and getdate();
		SET NOCOUNT OFF;
	END
GO

EXEC [DeduccionesMontoMes] @inIdUsuario = 1

DROP PROCEDURE IF EXISTS [dbo].[RetornarJueves]


CREATE PROCEDURE [dbo].[RetornarJueves] @inFecha DATE, @outFecha DATE OUTPUT

	AS BEGIN

		SET NOCOUNT ON
		
		DECLARE @InicioMes DATE = DATEADD(DAY,1,EOMONTH(@inFecha))

		DECLARE @NumDia INT = DATEPART(WEEKDAY,@InicioMes)

		DECLARE @DiferenciaJ INT = 5-@NumDia

		DECLARE @Jueves DATE = DATEADD(DAY,@DiferenciaJ,@InicioMes)

		SELECT @outFecha = @Jueves

		SET NOCOUNT OFF
	END
GO


