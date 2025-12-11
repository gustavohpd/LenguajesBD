<?php
// ===============================================
//                CORS – MUST BE FIRST
// ===============================================
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Expose-Headers: *");

// OPTIONS must exit before ANY logic
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// ===============================================
//  REQUIRE FILES
// ===============================================
require_once __DIR__ . '/../src/Database.php';
require_once __DIR__ . '/../routes/clientes.php';
require_once __DIR__ . '/../routes/productos.php';
require_once __DIR__ . '/../routes/servicios.php';
require_once __DIR__ . '/../routes/citas.php';
require_once __DIR__ . '/../routes/login.php';
require_once __DIR__ . '/../routes/registro.php';
require_once __DIR__ . '/../routes/pago.php';   // <<------------------ AGREGADO
require_once __DIR__ . '/../routes/proveedores.php';


// ===============================================
//  NORMALIZE ROUTE
// ===============================================
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Remove everything before /api/
$endpoint = preg_replace('#^.*?/public/index\.php/?#', '/', $uri);

if ($endpoint === '' || $endpoint === false) {
    $endpoint = '/';
}

$method = $_SERVER['REQUEST_METHOD'];

// ===============================================
//               AUTH (LOGIN / REGISTRO)
// ===============================================
if ($endpoint === '/api/login' && $method === 'POST') {
    loginUsuario();
    exit;
}

if ($endpoint === '/api/registro' && $method === 'POST') {
    registrarUsuario();
    exit;
}

// ===============================================
//               CLIENTES
// ===============================================
if ($endpoint === '/api/clientes' && $method === 'GET') {
    getClientes();
    exit;
}

if ($endpoint === '/api/clientes' && $method === 'POST') {
    createCliente();
    exit;
}

if (preg_match('/^\/api\/clientes\/(\d+)$/', $endpoint, $id)) {
    if ($method === 'GET') { getClienteById($id[1]); exit; }
    if ($method === 'PUT') { updateCliente($id[1]); exit; }
    if ($method === 'DELETE') { deleteCliente($id[1]); exit; }
}

// ===============================================
//               PRODUCTOS
// ===============================================
if ($endpoint === '/api/productos' && $method === 'GET') {
    getProductos();
    exit;
}

if ($endpoint === '/api/productos' && $method === 'POST') {
    createProducto();
    exit;
}

if (preg_match('/^\/api\/productos\/(\d+)$/', $endpoint, $id)) {
    if ($method === 'GET') { getProductoById($id[1]); exit; }
    if ($method === 'PUT') { updateProducto($id[1]); exit; }
    if ($method === 'DELETE') { deleteProducto($id[1]); exit; }
}

// ===============================================
//               SERVICIOS
// ===============================================
if ($endpoint === '/api/servicios' && $method === 'GET') {
    getServicios();
    exit;
}

if ($endpoint === '/api/servicios' && $method === 'POST') {
    createServicio();
    exit;
}

if (preg_match('/^\/api\/servicios\/(\d+)$/', $endpoint, $id)) {
    if ($method === 'GET') { getServicioById($id[1]); exit; }
    if ($method === 'PUT') { updateServicio($id[1]); exit; }
    if ($method === 'DELETE') { deleteServicio($id[1]); exit; }
}

// ===============================================
//               CITAS
// ===============================================
if ($endpoint === '/api/citas' && $method === 'GET') {
    getCitas();
    exit;
}

if ($endpoint === '/api/citas' && $method === 'POST') {
    createCita();
    exit;
}

if (preg_match('/^\/api\/citas\/(\d+)$/', $endpoint, $id)) {
    if ($method === 'GET') { getCitaById($id[1]); exit; }
    if ($method === 'PUT') { updateCita($id[1]); exit; }
    if ($method === 'DELETE') { deleteCita($id[1]); exit; }
}
// ===============================================
//               PROVEEDORES
// ===============================================
if ($endpoint === '/api/proveedores' && $method === 'GET') {
    getProveedores();
    exit;
}

if ($endpoint === '/api/proveedores' && $method === 'POST') {
    createProveedor();
    exit;
}

if (preg_match('/^\/api\/proveedores\/(\d+)$/', $endpoint, $id)) {
    if ($method === 'GET') { getProveedorById($id[1]); exit; }
    if ($method === 'PUT') { updateProveedor($id[1]); exit; }
    if ($method === 'DELETE') { deleteProveedor($id[1]); exit; }
}


// ===============================================
//                      PAGOS
// ===============================================
if ($endpoint === '/api/pago' && $method === 'POST') {
    procesarPago();
    exit;
}

// ===============================================
//          FALLBACK → 404 NOT FOUND
// ===============================================
http_response_code(404);
echo json_encode([
    'error' => 'Ruta no encontrada',
    'endpoint' => $endpoint
]);
