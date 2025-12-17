<?php
// 1. Permite que el navegador reciba la respuesta (CORS)
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// 2. Datos de conexión al servidor SQL
$serverName = "127.0.0.1, 1433"; // Cámbialo por el tuyo, estaba $serverName = "NOMBRE_DE_TU_PC\SQLEXPRESS"; 
$connectionOptions = array(
    "Database" => "UsuariosApp",
    "Uid" => "usuario_php", // queda vacío si se usa autenticación de Windows
    "PWD" => "usuario_php"
);

// 3. genera conexión
$conn = sqlsrv_connect($serverName, $connectionOptions);

if ($conn === false) {
    $errores = sqlsrv_errors();
    echo json_encode([
        "status" => "error", 
        "message" => "Error de conexión: " . $errores[0]['message']
    ]);
    exit;
}

// 4. Leo los datos que vienen desde el JavaScript
// php://input es donde llega el paquete JSON de 'fetch'
$jsonInput = file_get_contents('php://input');
$datos = json_decode($jsonInput);

// 5. Preparo la consulta SQL (se usa '?' por seguridad contra ataques)
$sql = "INSERT INTO registros (nombre, edad, genero, pais, profesion) VALUES (?, ?, ?, ?, ?)";
$params = array(
    $datos->nombre, 
    $datos->edad, 
    $datos->genero, 
    $datos->pais, 
    $datos->profesion
);

// 6. Ejecuto la consulta
$stmt = sqlsrv_query($conn, $sql, $params);

if ($stmt) {
    echo json_encode(["status" => "success", "message" => "Guardado en SQL Server"]);
// Cambia esto:
} else {
    echo json_encode(["status" => "error", "message" => print_r(sqlsrv_errors(), true)]);
}

// 7. cierro la conexión
sqlsrv_free_stmt($stmt);
sqlsrv_close($conn);
?>