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