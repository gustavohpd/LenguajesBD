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

// Listar
function getClientes() {
    global $conn;

    $sql = 'BEGIN FIDE_CLIENTES_LISTAR_SP(:cursor); END;';
    $stid = oci_parse($conn, $sql);

    $cursor = oci_new_cursor($conn);
    oci_bind_by_name($stid, ":cursor", $cursor, -1, SQLT_RSET);

    oci_execute($stid);
    oci_execute($cursor);

    $clientes = [];

    while ($row = oci_fetch_array($cursor, OCI_ASSOC+OCI_RETURN_NULLS)) {
        $row = array_change_key_case($row, CASE_LOWER);

        // Convertir LOBs, fechas y utf8
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
        $clientes[] =  $row;
    }

    echo json_encode($clientes, JSON_UNESCAPED_UNICODE);
}

// Funciones CRUD utilizando procedimientos almacenados

// Obtener  cliente x ID
function getClienteById($cliente_id) {
    global $conn;

    $sql = 'BEGIN FIDE_CLIENTES_OBTENER_SP(:p_cliente_id, :cursor); END;';
    $stid = oci_parse($conn, $sql);

    $cursor = oci_new_cursor($conn);

    oci_bind_by_name($stid, ':p_cliente_id', $cliente_id);
    oci_bind_by_name($stid, ':cursor', $cursor, -1, SQLT_RSET);

    oci_execute($stid);
    oci_execute($cursor);

    $row = oci_fetch_array($cursor, OCI_ASSOC + OCI_RETURN_NULLS);

    if (!$row) {
        http_response_code(404);
        echo json_encode(['error' => 'Cliente no encontrado']);
        return;
    }

    // Convertir LOBs y UTF-8
    foreach ($row as $key => $value) {
        if ($value instanceof OCI_Lob) {
            $row[$key] = $value->load();
        }
        if (is_string($row[$key])) {
            $row[$key] = utf8_encode($row[$key]);
        }
    }

    $row = array_change_key_case($row, CASE_LOWER);

    echo json_encode($row, JSON_UNESCAPED_UNICODE);
}



// Crear un nuevo cliente
function createCliente() {
    global $conn;
    $input = json_decode(file_get_contents("php://input"), true);

    if (
        isset($input['cliente_id'], 
              $input['usuario_id'], 
              $input['preferencias'], 
              $input['historial'])
    ) {
        $cliente_id   = $input['cliente_id'];
        $usuario_id   = $input['usuario_id'];
        $estado_id    = $input['estado_id'] ?? 1; // Valor por defecto
        $preferencias = $input['preferencias'];
        $historial    = $input['historial'];

        $stid = oci_parse($conn, '
            BEGIN 
              FIDE_CLIENTES_INSERTAR_SP(
                :cliente_id, 
                :usuario_id, 
                :estado_id, 
                :preferencias, 
                :historial
              ); 
            END;
        ');

        oci_bind_by_name($stid, ":cliente_id",   $cliente_id);
        oci_bind_by_name($stid, ":usuario_id",   $usuario_id);
        oci_bind_by_name($stid, ":estado_id",    $estado_id);
        oci_bind_by_name($stid, ":preferencias", $preferencias);
        oci_bind_by_name($stid, ":historial",    $historial);

        if (oci_execute($stid)) {
            oci_commit($conn);
            echo json_encode(['message' => 'Cliente creado exitosamente']);
        } else {
            $e = oci_error($stid);
            http_response_code(500);
            echo json_encode(['error' => 'Error al crear el cliente', 'detalle' => $e['message']]);
        }

    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Datos incompletos']);
    }
}


// Actualizar un cliente
function updateCliente($id) {
    global $conn;
    $input = json_decode(file_get_contents("php://input"), true);

    if (
        isset($input['usuario_id'], 
              $input['estado_id'], 
              $input['preferencias'], 
              $input['historial'])
    ) {

        $usuario_id   = $input['usuario_id'];
        $estado_id    = $input['estado_id'];
        $preferencias = $input['preferencias'];
        $historial    = $input['historial'];

        $stid = oci_parse($conn, '
            BEGIN 
              FIDE_CLIENTES_MODIFICAR_SP(
                :cliente_id,
                :usuario_id,
                :estado_id,
                :preferencias,
                :historial
              ); 
            END;
        ');

        oci_bind_by_name($stid, ":cliente_id",   $id);
        oci_bind_by_name($stid, ":usuario_id",   $usuario_id);
        oci_bind_by_name($stid, ":estado_id",    $estado_id);
        oci_bind_by_name($stid, ":preferencias", $preferencias);
        oci_bind_by_name($stid, ":historial",    $historial);

        if (oci_execute($stid)) {
            oci_commit($conn);
            echo json_encode(['message' => 'Cliente actualizado exitosamente']);
        } else {
            $e = oci_error($stid);
            http_response_code(500);
            echo json_encode(['error' => 'Error al actualizar el cliente', 'detalle' => $e['message']]);
        }

    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Datos incompletos']);
    }
}


// Eliminar un cliente
function deleteCliente($id) {
    global $conn;

    $stid = oci_parse($conn, 'BEGIN FIDE_CLIENTES_ELIMINAR_SP(:id); END;');
    oci_bind_by_name($stid, ":id", $id, -1, SQLT_INT);

    // Ejecutar procedimiento
    if (oci_execute($stid)) {
        oci_commit($conn);
        echo json_encode(['message' => 'Cliente eliminado (estado actualizado a 2)']);
    } else {
        $e = oci_error($stid);
        http_response_code(500);
        echo json_encode([
            'error' => 'Error al eliminar el cliente',
            'detalle' => $e['message']
        ]);
    }
}   