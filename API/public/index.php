<?php
require_once __DIR__ . '/../src/Database.php';
require_once __DIR__ . '/../routes/clientes.php';
require_once __DIR__ . '/../routes/productos.php';
require_once __DIR__ . '/../routes/servicios.php'; // ← NUEVO

// CORS básico
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Manejo del preflight OPTIONS para CORS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header("HTTP/1.1 200 OK");
    exit();
}

// Obtener URI limpia
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Ajusta esto según tu entorno
$base = '/LenguajesBD/API/public/index.php';
$endpoint = substr($uri, strlen($base));

$method = $_SERVER['REQUEST_METHOD'];


// =====================================================
//                       CLIENTES
// =====================================================

if ($endpoint === '/api/clientes' && $method === 'GET') {
    getClientes();
    exit;
}

if ($endpoint === '/api/clientes' && $method === 'POST') {
    createCliente();
    exit;
}

if (preg_match('/^\/api\/clientes\/(\d+)$/', $endpoint, $matches) && $method === 'GET') {
    getClienteById($matches[1]);
    exit;
}

if (preg_match('/^\/api\/clientes\/(\d+)$/', $endpoint, $matches) && $method === 'PUT') {
    updateCliente($matches[1]);
    exit;
}

if (preg_match('/^\/api\/clientes\/(\d+)$/', $endpoint, $matches) && $method === 'DELETE') {
    deleteCliente($matches[1]);
    exit;
}



// =====================================================
//                       PRODUCTOS
// =====================================================

if ($endpoint === '/api/productos' && $method === 'GET') {
    getProductos();
    exit;
}

if ($endpoint === '/api/productos' && $method === 'POST') {
    createProducto();
    exit;
}

if (preg_match('/^\/api\/productos\/(\d+)$/', $endpoint, $matches) && $method === 'GET') {
    getProductoById($matches[1]);
    exit;
}

if (preg_match('/^\/api\/productos\/(\d+)$/', $endpoint, $matches) && $method === 'PUT') {
    updateProducto($matches[1]);
    exit;
}

if (preg_match('/^\/api\/productos\/(\d+)$/', $endpoint, $matches) && $method === 'DELETE') {
    deleteProducto($matches[1]);
    exit;
}



// =====================================================
//                       SERVICIOS
// =====================================================

// GET todos
if ($endpoint === '/api/servicios' && $method === 'GET') {
    getServicios();
    exit;
}

// POST crear
if ($endpoint === '/api/servicios' && $method === 'POST') {
    createServicio();
    exit;
}

// GET por ID
if (preg_match('/^\/api\/servicios\/(\d+)$/', $endpoint, $matches) && $method === 'GET') {
    getServicioById($matches[1]);
    exit;
}

// PUT modificar
if (preg_match('/^\/api\/servicios\/(\d+)$/', $endpoint, $matches) && $method === 'PUT') {
    updateServicio($matches[1]);
    exit;
}

// DELETE (estado=2)
if (preg_match('/^\/api\/servicios\/(\d+)$/', $endpoint, $matches) && $method === 'DELETE') {
    deleteServicio($matches[1]);
    exit;
}



// =====================================================
//                 RUTA NO ENCONTRADA
// =====================================================

http_response_code(404);
echo json_encode(['error' => 'Ruta no encontrada']);
