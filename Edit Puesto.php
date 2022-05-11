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

$IDE = $puestoE = $salarioE = "";

?>


<div id="info" class="container">
<h1>Admin Controls</h1>
<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>"> 
<h3>Editar Empleado</h3>
  ID del Puesto a Editar: <input type="number" name="IDPD" value="<?php echo $IDE;?>">
  <br><br>
  Nombre: <input type="text" name="puestoPD" value="<?php echo $puestoE;?>">
  <br><br>
  Salario por Hora: <input type="number" name="salarioPD" value="<?php echo $tipoDocE;?>">
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
        $IDE = test_input($_POST["IDPD"]);
        $puestoE = test_input($_POST["puestoPD"]);
        $salarioE = test_input($_POST["salarioPD"]);

        if(empty($IDE)||empty($puestoE)||empty($salarioE)){
            echo "Hay espacios vacios";
        }
        else{
            $tsql = "EXEC [dbo].[editarPuesto] @inId = $IDE, @inNombre = $puestoE, @inSalario = $salarioE";
            $stmt = sqlsrv_query($conn, $tsql);
            $check = sqlsrv_fetch($stmt);
            echo "El puesto ha sido editado";
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
