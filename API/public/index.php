<?php
require_once __DIR__ . '/../src/Database.php';

// CORS básico
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Rutas simples basado en PATH_INFO
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// ajustar si estás usando subcarpeta /php-oracle-api/public
$base = '/angelus_estetica/API/public/index.php'; // <- ajusta según tu setup, o deja '' si pruebas con php -S

$endpoint = substr($uri, strlen($base));

if ($endpoint === '/api/clientes' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    require __DIR__ . '/../routes/clientes.php';
    exit;
}

http_response_code(404);
echo json_encode(['error' => 'Ruta no encontrada']);
