<?php
header('Content-Type: application/json; charset=utf-8');

try {
    $db = new Database([
        'DB_USER' => 'ANGELUS_ESTETICA',
        'DB_PASS' => 'ag123',
        'DB_HOST' => 'localhost',
        'DB_PORT' => '1521',
        'DB_SERVICE' => 'xe'
    ]);

    if ($db->getType() === 'pdo') {
        $pdo = $db->getConnection();
    } else {
        $conn = $db->getConnection();
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}

// ===========================================================
// LISTAR PRODUCTOS
// ===========================================================
function getProductos() {
    global $conn;

    $sql = 'BEGIN FIDE_PRODUCTOS_LISTAR_SP(:cursor); END;';
    $stid = oci_parse($conn, $sql);

    $cursor = oci_new_cursor($conn);
    oci_bind_by_name($stid, ":cursor", $cursor, -1, SQLT_RSET);

    oci_execute($stid);
    oci_execute($cursor);

    $productos = [];

    while ($row = oci_fetch_array($cursor, OCI_ASSOC+OCI_RETURN_NULLS)) {
        $row = array_change_key_case($row, CASE_LOWER);

        foreach ($row as $key => $value) {

            if ($value instanceof OCI_Lob) {
                $row[$key] = $value->read($value->size());
            }

            if ($value instanceof DateTime) {
                $row[$key] = $value->format('Y-m-d H:i:s');
            }

            if (is_string($value)) {
                $row[$key] = utf8_encode($value);
            }
        }

        $productos[] = $row;
    }

    echo json_encode($productos, JSON_UNESCAPED_UNICODE);
}


// ===========================================================
// OBTENER PRODUCTO POR ID
// ===========================================================
function getProductoById($producto_id) {
    global $conn;

    $sql = 'BEGIN FIDE_PRODUCTOS_OBTENER_SP(
                :p_producto_id,
                :p_categoria_id,
                :p_estado_id,
                :p_proveedor_id,
                :p_nombre,
                :p_descripcion,
                :p_precio
            ); END;';

    $stid = oci_parse($conn, $sql);

    oci_bind_by_name($stid, ":p_producto_id", $producto_id);

    // Variables OUT
    oci_bind_by_name($stid, ":p_categoria_id", $categoria_id, 255);
    oci_bind_by_name($stid, ":p_estado_id", $estado_id, 255);
    oci_bind_by_name($stid, ":p_proveedor_id", $proveedor_id, 255);
    oci_bind_by_name($stid, ":p_nombre", $nombre, 255);
    oci_bind_by_name($stid, ":p_descripcion", $descripcion, 4000);
    oci_bind_by_name($stid, ":p_precio", $precio, 255);

    oci_execute($stid);

    if ($nombre === null) {
        http_response_code(404);
        echo json_encode(['error' => 'Producto no encontrado']);
        return;
    }

    $row = [
        'producto_id'  => $producto_id,
        'categoria_id' => $categoria_id,
        'estado_id'    => $estado_id,
        'proveedor_id' => $proveedor_id,
        'nombre'       => utf8_encode($nombre),
        'descripcion'  => utf8_encode($descripcion),
        'precio'       => $precio
    ];

    echo json_encode($row, JSON_UNESCAPED_UNICODE);
}


// ===========================================================
// CREAR PRODUCTO
// ===========================================================
function createProducto() {
    global $conn;
    $input = json_decode(file_get_contents("php://input"), true);

    if (
        isset($input['producto_id'], 
              $input['categoria_id'], 
              $input['proveedor_id'],
              $input['nombre'],
              $input['descripcion'],
              $input['precio'])
    ) {
        $producto_id  = $input['producto_id'];
        $categoria_id = $input['categoria_id'];
        $estado_id    = $input['estado_id'] ?? 1;
        $proveedor_id = $input['proveedor_id'];
        $nombre       = $input['nombre'];
        $descripcion  = $input['descripcion'];
        $precio       = $input['precio'];

        $stid = oci_parse($conn, '
            BEGIN 
              FIDE_PRODUCTOS_INSERTAR_SP(
                :producto_id,
                :categoria_id,
                :estado_id,
                :proveedor_id,
                :nombre,
                :descripcion,
                :precio
              ); 
            END;
        ');

        oci_bind_by_name($stid, ":producto_id",  $producto_id);
        oci_bind_by_name($stid, ":categoria_id", $categoria_id);
        oci_bind_by_name($stid, ":estado_id",    $estado_id);
        oci_bind_by_name($stid, ":proveedor_id", $proveedor_id);
        oci_bind_by_name($stid, ":nombre",       $nombre);
        oci_bind_by_name($stid, ":descripcion",  $descripcion);
        oci_bind_by_name($stid, ":precio",       $precio);

        if (oci_execute($stid)) {
            echo json_encode(['message' => 'Producto creado exitosamente']);
        } else {
            $e = oci_error($stid);
            http_response_code(500);
            echo json_encode(['error' => 'Error al crear el producto', 'detalle' => $e['message']]);
        }

    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Datos incompletos']);
    }
}


// ===========================================================
// ACTUALIZAR PRODUCTO
// ===========================================================
function updateProducto($id) {
    global $conn;
    $input = json_decode(file_get_contents("php://input"), true);

    if (
        isset($input['categoria_id'], 
              $input['estado_id'], 
              $input['proveedor_id'],
              $input['nombre'], 
              $input['descripcion'], 
              $input['precio'])
    ) {

        $categoria_id = $input['categoria_id'];
        $estado_id    = $input['estado_id'];
        $proveedor_id = $input['proveedor_id'];
        $nombre       = $input['nombre'];
        $descripcion  = $input['descripcion'];
        $precio       = $input['precio'];

        $stid = oci_parse($conn, '
            BEGIN 
              FIDE_PRODUCTOS_MODIFICAR_SP(
                :producto_id,
                :categoria_id,
                :estado_id,
                :proveedor_id,
                :nombre,
                :descripcion,
                :precio
              ); 
            END;
        ');

        oci_bind_by_name($stid, ":producto_id",  $id);
        oci_bind_by_name($stid, ":categoria_id", $categoria_id);
        oci_bind_by_name($stid, ":estado_id",    $estado_id);
        oci_bind_by_name($stid, ":proveedor_id", $proveedor_id);
        oci_bind_by_name($stid, ":nombre",       $nombre);
        oci_bind_by_name($stid, ":descripcion",  $descripcion);
        oci_bind_by_name($stid, ":precio",       $precio);

        if (oci_execute($stid)) {
            echo json_encode(['message' => 'Producto actualizado exitosamente']);
        } else {
            $e = oci_error($stid);
            http_response_code(500);
            echo json_encode(['error' => 'Error al actualizar el producto', 'detalle' => $e['message']]);
        }

    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Datos incompletos']);
    }
}


// ===========================================================
// ELIMINAR PRODUCTO
// ===========================================================
function deleteProducto($id) {
    global $conn;

    $stid = oci_parse($conn, 'BEGIN FIDE_PRODUCTOS_ELIMINAR_SP(:id); END;');
    oci_bind_by_name($stid, ":id", $id, -1, SQLT_INT);

    if (oci_execute($stid)) {
        echo json_encode(['message' => 'Producto eliminado (estado actualizado a 2)']);
    } else {
        $e = oci_error($stid);
        http_response_code(500);
        echo json_encode([
            'error' => 'Error al eliminar el producto',
            'detalle' => $e['message']
        ]);
    }
}

