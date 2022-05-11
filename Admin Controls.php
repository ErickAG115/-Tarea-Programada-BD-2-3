<!DOCTYPE HTML>  
<html>
<head>
<style>
.error {color: #FF0000;}
.success {color: #008000;}
</style>
</head>
<body> 

<?php


$serverName = 'ERICK';
$connectionInfo = array('Database'=>'ProyectoBD');
$conn = sqlsrv_connect($serverName, $connectionInfo);

$name = $filtro = $insertPN = $insertPS = $nombreE = $puestoE = $tipoDocE = $valorDocE = $depE = $fechaE = $ID = "";


?>
<div id="info" class="container">
<h1>Admin Controls</h1>
<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>"> 
  <h3>Listado y Edicion</h3>
  <input type="submit" name="submit" value="Listar Puestos">
  <br><br>
  <input type="submit" name="submit" value="Listar Empleados">
  <br><br>
  <input type="submit" name="submit" value="Editar Puestos">
  <br><br>
  <input type="submit" name="submit" value="Editar Empleados">
  <br><br>
  Listar Empleados (Nombre): <input type="text" name="filtroN" value="<?php echo $filtro;?>">
  <input type="submit" name="submit" value="Listar Filtro">
  <br><br>
  <h3>Borrar</h3>
  ID Empleado: <input type="number" name="IDE" value="<?php echo $insertPN;?>">
  <br><br>
  <input type="submit" name="submit" value="Borrar Empleado">
  <br><br>
  ID Puesto: <input type="number" name="IDP" value="<?php echo $insertPN;?>">
  <br><br>
  <input type="submit" name="submit" value="Borrar Puesto">
  <br><br>
  <h3>Insertar Nuevo Puesto</h3>
  Nombre: <input type="text" name="namePI" value="<?php echo $insertPN;?>">
  <br><br>
  Salario por Hora: <input type="number" name="pricePI" value="<?php echo $insertPS;?>">
  <br><br>
  <input type="submit" name="submit" value="Insertar Puesto">
  <br><br>
  <h3>Insertar Nuevo Empleado</h3>
  Nombre: <input type="text" name="nameEI" value="<?php echo $nombreE;?>">
  <br><br>
  Tipo Doc.Identidad: <input type="number" name="tipoEI" value="<?php echo $tipoDocE;?>">
  <br><br>
  Valor Identidad: <input type="number" name="valorEI" value="<?php echo $valorDocE;?>">
  <br><br>
  Puesto: <input type="text" name="puestoEI" value="<?php echo $puestoE;?>">
  <br><br>
  Fecha de Nacimiento: <input type="text" name="fechaEI" value="<?php echo $fechaE;?>">
  <br><br>
  ID de Departamento: <input type="number" name="depEI" value="<?php echo $depE;?>">
  <br><br>
  <input type="submit" name="submit" value="Insertar Empleado">
  <br><br>
  <h3>Salir</h3>
  <input type="submit" name="submit" value="Log Off">
  <br><br>
</form>
</div>
<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  if($_POST['submit'] == 'Log Off'){
    header("Location: http://localhost/php_program/Log%20In%20Admin.php");
    exit();
  }
  else if($_POST['submit'] == 'Editar Puestos'){
    header("Location: http://localhost/php_program/Edit%20Puesto.php");
    exit();
  }
  else if($_POST['submit'] == 'Editar Empleados'){
    header("Location: http://localhost/php_program/Edit%20Employee.php");
    exit();
  }
  else if($_POST['submit'] == 'Borrar Empleado'){
    $ID = test_input($_POST["IDE"]);
    if(empty($ID)){
      echo "Hay espacios vacios";
    }
    else{
      $tsql = "EXEC [dbo].[borrarEmpleado] @inID = $ID";
      $stmt = sqlsrv_query($conn, $tsql);
      $check = sqlsrv_fetch($stmt);
      echo "El empleado ha sido borrado";
    }
  }
  else if($_POST['submit'] == 'Borrar Puesto'){
    $ID = test_input($_POST["IDP"]);
    if(empty($ID)){
      echo "Hay espacios vacios";
    }
    else{
      $tsql = "EXEC [dbo].[borrarPuesto] @inID = $ID";
      $stmt = sqlsrv_query($conn, $tsql);
      $check = sqlsrv_fetch($stmt);
      echo "El puesto ha sido borrado";
    }
  }
  else if($_POST['submit'] == 'Listar Puestos'){
    $tsql = "EXEC [filtrarNombre]";
    $stmt = sqlsrv_query( $conn, $tsql);
    echo "<table border='4' class='stats' cellspacing='0'>
          <tr>
          <td class='hed' colspan='8'>Listado de Puestos</td>
          </tr>
          <tr>
          <th>Nombre</th>
          <th>Salario por hora</th>
          </tr>"; 
    while( $row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC) ) {
      echo "<tr>";
      echo "<td>" . $row['NombreP'] . "</td>";
      echo "<td>" . $row['SalarioXHora'] . "</td>";
      echo "</tr>";
    }
  }
  else if($_POST['submit'] == 'Listar Empleados'){
    $tsql = "EXEC [listarEmpleados]";
    $stmt = sqlsrv_query( $conn, $tsql);
    echo "<table border='4' class='stats' cellspacing='0'>
          <tr>
          <td class='hed' colspan='8'>Listado de Empleados</td>
          </tr>
          <tr>
          <th>ID</th>
          <th>Nombre</th>
          <th>Puesto</th>
          <th>Tipo de DocIdentidad</th>
          <th>Valor de DocIdentidad</th>
          <th>Fecha de Nacimiento</th>
          <th>Departamento</th>
          </tr>"; 
    while( $row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC) ) {
      $date = date_format($row['FechaNacimiento'],"Ymd");
      echo "<tr>";
      echo "<td>" . $row['ID'] . "</td>";
      echo "<td>" . $row['Nombre'] . "</td>";
      echo "<td>" . $row['NombreP'] . "</td>";
      echo "<td>" . $row['NombreTip'] . "</td>";
      echo "<td>" . $row['ValorDocIdentidad'] . "</td>";
      echo "<td>" . $date . "</td>";
      echo "<td>" . $row['NombreDep'] . "</td>";
      echo "</tr>";
    }
  }
  else if($_POST['submit'] == 'Listar Filtro'){
    $filtro = test_input($_POST["filtroN"]);
    $tsql = "EXEC [dbo].[listarEmpleadosFiltro] @inNombre = '$filtro'";
    $stmt = sqlsrv_query( $conn, $tsql);
    echo "<table border='4' class='stats' cellspacing='0'>
          <tr>
          <td class='hed' colspan='8'>Listado de Empleados</td>
          </tr>
          <tr>
          <th>ID</th>
          <th>Nombre</th>
          <th>Puesto</th>
          <th>Tipo de DocIdentidad</th>
          <th>Valor de DocIdentidad</th>
          <th>Fecha de Nacimiento</th>
          <th>Departamento</th>
          </tr>"; 
    while( $row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC) ) {
      $date = date_format($row['FechaNacimiento'],"Ymd");
      echo "<tr>";
      echo "<td>" . $row['ID'] . "</td>";
      echo "<td>" . $row['Nombre'] . "</td>";
      echo "<td>" . $row['NombreP'] . "</td>";
      echo "<td>" . $row['NombreTip'] . "</td>";
      echo "<td>" . $row['ValorDocIdentidad'] . "</td>";
      echo "<td>" . $date . "</td>";
      echo "<td>" . $row['NombreDep'] . "</td>";
      echo "</tr>";
    }
  }
  else if($_POST['submit'] == 'Insertar Puesto'){
    $insertPN = test_input($_POST["namePI"]);
    $insertPS = test_input($_POST["pricePI"]);
    if(empty($insertPN)||empty($insertPS)){
      echo "Hay espacios vacios";
    }
    else{
      $tsql = "EXEC [dbo].[insertarPuesto] @inNombre = $insertPN, @inSalario = $insertPS";
      $stmt = sqlsrv_query($conn, $tsql);
      $check = sqlsrv_fetch($stmt);
      echo "El puesto ha sido insertado";
    }
  }
  else if($_POST['submit'] == 'Insertar Empleado'){
    $nombreE = test_input($_POST["nameEI"]);
    $tipoDocE = test_input($_POST["tipoEI"]);
    $valorDocE = test_input($_POST["valorEI"]);
    $puestoE = test_input($_POST["puestoEI"]);
    $fechaE = test_input($_POST["fechaEI"]);
    $depE = test_input($_POST["tipoEI"]);

    if(empty($nombreE)||empty($tipoDocE)||empty($valorDocE)||empty($puestoE)||empty($fechaE)||empty($depE)){
      echo "Hay espacios vacios";
    }
    else{
      $tsql = "EXEC [dbo].[insertarEmpleado] @inNombre = $nombreE, @inIdTipoDocIdentidad = $tipoDocE, @inValorDocIdentidad = $valorDocE, @inPuesto = $puestoE, @inFechaNacimiento = $fechaE, @inIdDepartamento = $depE";
      $stmt = sqlsrv_query($conn, $tsql);
      $check = sqlsrv_fetch($stmt);
      echo "El empleado ha sido insertado";
    }
  }
}

function test_input($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}
?>
</body>
</html>