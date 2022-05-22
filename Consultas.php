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

session_start();

$serverName = 'ERICK';
$connectionInfo = array('Database'=>'ProyectoBD');
$conn = sqlsrv_connect($serverName, $connectionInfo);

$Usuario = "";

if(isset($_SESSION['Usuario']))
    $Usuario = $_SESSION['Usuario'];

if($_GET){
  $Usuario = $_GET['user']; // print_r($_GET); //remember to add semicolon      
}else{
  $Usuario = $Usuario;
}

$_SESSION['Usuario'] = $Usuario;

$name = $filtro = $insertPN = $insertPS = $nombreE = $puestoE = $tipoDocE = $valorDocE = $depE = $fechaE = $ID = "";


?>
<div id="info" class="container">
<h1>Consulta de Planillas</h1>
<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>"> 
  <input type="submit" name="submit" value="Planillas Semanales">
  <input type="submit" name="submit" value="Planillas Mensuales">
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