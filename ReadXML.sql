use [ProyectoBD]

DECLARE @xmlData XML

SET @xmlData = (
		SELECT *
		FROM OPENROWSET(BULK 'C:\Users\eastorga\Documents\GitHub\-Tarea-Programada-BD-2-3\DatosTarea2.xml', SINGLE_BLOB) 
		AS xmlData
		);


INSERT INTO dbo.Departamentos(ID, NombreDep)
SELECT  
	T.Item.value('@Id', 'INT'),
	T.Item.value('@Nombre', 'VARCHAR(128)')
FROM @xmlData.nodes('Datos/Departamentos/Departamento') as T(Item)

INSERT INTO dbo.Puesto(NombreP, SalarioXHora, Borrado)
SELECT  
	T.Item.value('@Nombre', 'VARCHAR(128)'),
	T.Item.value('@SalarioXHora', 'MONEY'),
	1
FROM @xmlData.nodes('Datos/Puestos/Puesto') as T(Item)

INSERT INTO dbo.TipoDocIdentidad(ID, NombreTip)
SELECT  
	T.Item.value('@Id', 'INT'),
	T.Item.value('@Nombre', 'VARCHAR(128)')
FROM @xmlData.nodes('Datos/Tipo_Doc/TipoDocuIdentidad') as T(Item)

INSERT INTO dbo.Usuarios(Nombre, Password)
SELECT  
	T.Item.value('@Nombre', 'VARCHAR(16)'),
	T.Item.value('@Password', 'VARCHAR(16)')
FROM @xmlData.nodes('Datos/Usuarios/Usuario') as T(Item)

INSERT INTO dbo.Obrero(Nombre, IdTipoDocIdentidad, ValorDocIdentidad, IdDepartamento, IdPuesto, FechaNacimiento, Borrado)
SELECT  
	T.Item.value('@Nombre', 'VARCHAR(128)'),
	T.Item.value('@IdTipoIdentificacion', 'INT'),
	T.Item.value('@ValorDocumentoIdentificacion', 'INT'),
	T.Item.value('@IdDepartamento', 'INT'),
	(SELECT P.ID FROM dbo.Puesto P WHERE P.NombreP = (Item.value('@Puesto', 'VARCHAR(128)'))),
	T.Item.value('@FechaNacimiento', 'Date'),
	1
FROM @xmlData.nodes('Datos/Empleados/Empleado') as T(Item)

