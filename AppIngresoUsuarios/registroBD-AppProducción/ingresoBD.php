<?php
// 1. Configuración de errores y cabeceras (CORS)
ini_set('display_errors', 0); // No mostrar errores de texto que rompan el JSON
error_reporting(E_ALL);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// 2. Datos de conexión
$serverName = "192.168.200.36, 1433"; 
$connectionOptions = array(
    "Database" => "UsuariosApp",
    "Uid" => "usuario_php", 
    "PWD" => "usuario_php",
    "CharacterSet" => "UTF-8",
    "TrustServerCertificate" => true,
    "Encrypt" => false
);

// 3. Establecer conexión
$conn = sqlsrv_connect($serverName, $connectionOptions);

if ($conn === false) {
    $errores = sqlsrv_errors();
    echo json_encode([
        "status" => "error", 
        "message" => "Error de conexión: " . ($errores[0]['message'] ?? 'Desconocido')
    ]);
    exit;
}

// 4. Leer y decodificar datos del JavaScript
$jsonInput = file_get_contents('php://input');
$datos = json_decode($jsonInput);

// Verificación de seguridad: ¿Llegaron los datos?
if (!$datos) {
    echo json_encode(["status" => "error", "message" => "No se recibieron datos válidos"]);
    exit;
}

// 5. Preparar consulta e insertar
$sql = "INSERT INTO registros (nombre, edad, genero, pais, profesion) VALUES (?, ?, ?, ?, ?)";
$params = array(
    $datos->nombre ?? null, 
    $datos->edad ?? null, 
    $datos->genero ?? null, 
    $datos->pais ?? null, 
    $datos->profesion ?? null
);

// 6. Ejecutar
$stmt = sqlsrv_query($conn, $sql, $params);

if ($stmt) {
    echo json_encode(["status" => "success", "message" => "Guardado correctamente en SQL Server"]);
} else {
    $errores = sqlsrv_errors();
    echo json_encode([
        "status" => "error", 
        "message" => "Error al insertar: " . ($errores[0]['message'] ?? 'Error de consulta')
    ]);
}

// 7. Cierre limpio
if ($stmt !== false && $stmt !== null) {
    sqlsrv_free_stmt($stmt);
}
sqlsrv_close($conn);
?>