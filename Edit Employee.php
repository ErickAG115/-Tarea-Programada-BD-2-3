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

$nombreE = $puestoE = $tipoDocE = $valorDocE = $depE = $fechaE = $IDE = "";

?>


<div id="info" class="container">
<h1>Admin Controls</h1>
<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>"> 
<h3>Editar Empleado</h3>
  ID del Empleado a Editar: <input type="number" name="IDED" value="<?php echo $IDE;?>">
  <br><br>
  Nombre: <input type="text" name="nameED" value="<?php echo $nombreE;?>">
  <br><br>
  Tipo Doc.Identidad: <input type="number" name="tipoED" value="<?php echo $tipoDocE;?>">
  <br><br>
  Valor Identidad: <input type="number" name="valorED" value="<?php echo $valorDocE;?>">
  <br><br>
  Fecha de Nacimiento: <input type="text" name="fechaED" value="<?php echo $fechaE;?>">
  <br><br>
  ID de Departamento: <input type="number" name="depED" value="<?php echo $depE;?>">
  <br><br>
  Puesto: <select name="puestoED">
    <?php
    $tsql = "EXEC retornarPuestos";
    $stmt = sqlsrv_query( $conn, $tsql);
    $check = sqlsrv_fetch($stmt);
    while( $row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC) ) {
        echo '<option value="' .($row['NombreP']) . '">'.($row['NombreP']) .'</option>';
    }
    ?>
  </select>
  <br><br>
  <input type="submit" name="submit" value="Editar">
  <br><br>
  <input type="submit" name="submit" value="Salir">
  <br><br>
</form>
</div>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if($_POST['submit'] == 'Editar'){
        $IDE = test_input($_POST["IDED"]);
        $nombreE = test_input($_POST["nameED"]);
        $tipoDocE = test_input($_POST["tipoED"]);
        $valorDocE = test_input($_POST["valorED"]);
        $fechaE = test_input($_POST["fechaED"]);
        $depE = test_input($_POST["tipoED"]);
        $puestoE = test_input($_POST["puestoED"]);

        if(empty($IDE)||empty($nombreE)||empty($tipoDocE)||empty($valorDocE)||empty($fechaE)||empty($depE)||empty($puestoE)){
            echo "Hay espacios vacios";
        }
        else{
            $tsql = "EXEC [dbo].[editarEmpleado] @inId = $IDE,@inNombre = $nombreE, @inTipoDocIdentidad = $tipoDocE, @inValorDocIdentidad = $valorDocE, @inFechaNacimiento = $fechaE, @inIdDepartamento = $depE, @inPuesto = $puestoE";
            $stmt = sqlsrv_query($conn, $tsql);
            $check = sqlsrv_fetch($stmt);
            echo "El empleado ha sido editado";
        }
    }
    else{
        header("Location: http://localhost/php_program/Admin%20Controls.php");
        exit();
    }
}

function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
  }
?>
