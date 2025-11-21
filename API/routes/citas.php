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

    $conn = $db->getConnection();

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}



// ================================
//     OBTENER TODOS LOS SERVICIOS
// ================================
function getServicios() {
    global $conn;

    $sql = 'BEGIN FIDE_SERVICIOS_OBTENER_TODOS_SP(:cursor); END;';
    $stid = oci_parse($conn, $sql);

    $cursor = oci_new_cursor($conn);
    oci_bind_by_name($stid, ":cursor", $cursor, -1, SQLT_RSET);

    oci_execute($stid);
    oci_execute($cursor);

    $servicios = [];

    while ($row = oci_fetch_array($cursor, OCI_ASSOC + OCI_RETURN_NULLS)) {
        $row = array_change_key_case($row, CASE_LOWER);

        foreach ($row as $key => $value) {
            if ($value instanceof OCI_Lob) {
                $row[$key] = $value->read($value->size());
            }
            if (is_string($value)) {
                $row[$key] = utf8_encode($value);
            }
        }

        $servicios[] = $row;
    }

    echo json_encode($servicios, JSON_UNESCAPED_UNICODE);
}



// ===================================
//     OBTENER SERVICIO POR ID
// ===================================
function getServicioById($id) {
    global $conn;

    $sql = 'BEGIN FIDE_SERVICIOS_OBTENER_POR_ID_SP(:p_servicio_id, :cursor); END;';
    $stid = oci_parse($conn, $sql);

    $cursor = oci_new_cursor($conn);

    oci_bind_by_name($stid, ':p_servicio_id', $id);
    oci_bind_by_name($stid, ':cursor', $cursor, -1, SQLT_RSET);

    oci_execute($stid);
    oci_execute($cursor);

    $row = oci_fetch_array($cursor, OCI_ASSOC + OCI_RETURN_NULLS);

    if (!$row) {
        http_response_code(404);
        echo json_encode(['error' => 'Servicio no encontrado']);
        return;
    }

    foreach ($row as $key => $value) {
        if ($value instanceof OCI_Lob) {
            $row[$key] = $value->load();
        }
        if (is_string($value)) {
            $row[$key] = utf8_encode($row[$key]);
        }
    }

    $row = array_change_key_case($row, CASE_LOWER);

    echo json_encode($row, JSON_UNESCAPED_UNICODE);
}



// ================================
//     INSERTAR SERVICIO
// ================================
function createServicio() {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);

    if (
        isset($input['servicio_id'], $input['categoria_id'], $input['nombre'],
              $input['descripcion'], $input['duracion'], $input['precio'])
    ) {
        $servicio_id  = $input['servicio_id'];
        $estado_id    = $input['estado_id'] ?? 1;
        $categoria_id = $input['categoria_id'];
        $nombre       = $input['nombre'];
        $descripcion  = $input['descripcion'];
        $duracion     = $input['duracion'];
        $precio       = $input['precio'];

        $stid = oci_parse($conn, '
            BEGIN 
              FIDE_SERVICIOS_INSERTAR_SP(
                :servicio_id,
                :estado_id,
                :categoria_id,
                :nombre,
                :descripcion,
                :duracion,
                :precio
              );
            END;
        ');

        oci_bind_by_name($stid, ":servicio_id",  $servicio_id);
        oci_bind_by_name($stid, ":estado_id",    $estado_id);
        oci_bind_by_name($stid, ":categoria_id", $categoria_id);
        oci_bind_by_name($stid, ":nombre",       $nombre);
        oci_bind_by_name($stid, ":descripcion",  $descripcion);
        oci_bind_by_name($stid, ":duracion",     $duracion);
        oci_bind_by_name($stid, ":precio",       $precio);

        if (oci_execute($stid)) {
            echo json_encode(['message' => 'Servicio creado exitosamente']);
        } else {
            $e = oci_error($stid);
            http_response_code(500);
            echo json_encode(['error' => 'Error al crear servicio', 'detalle' => $e['message']]);
        }

    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Datos incompletos']);
    }
}



// ================================
//     ACTUALIZAR SERVICIO
// ================================
function updateServicio($id) {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);

    if (
        isset($input['estado_id'], $input['categoria_id'], $input['nombre'],
              $input['descripcion'], $input['duracion'], $input['precio'])
    ) {

        $estado_id    = $input['estado_id'];
        $categoria_id = $input['categoria_id'];
        $nombre       = $input['nombre'];
        $descripcion  = $input['descripcion'];
        $duracion     = $input['duracion'];
        $precio       = $input['precio'];

        $stid = oci_parse($conn, '
            BEGIN 
              FIDE_SERVICIOS_MODIFICAR_SP(
                :servicio_id,
                :estado_id,
                :categoria_id,
                :nombre,
                :descripcion,
                :duracion,
                :precio
              );
            END;
        ');

        oci_bind_by_name($stid, ":servicio_id",  $id);
        oci_bind_by_name($stid, ":estado_id",    $estado_id);
        oci_bind_by_name($stid, ":categoria_id", $categoria_id);
        oci_bind_by_name($stid, ":nombre",       $nombre);
        oci_bind_by_name($stid, ":descripcion",  $descripcion);
        oci_bind_by_name($stid, ":duracion",     $duracion);
        oci_bind_by_name($stid, ":precio",       $precio);

        if (oci_execute($stid)) {
            echo json_encode(['message' => 'Servicio actualizado exitosamente']);
        } else {
            $e = oci_error($stid);
            http_response_code(500);
            echo json_encode(['error' => 'Error al actualizar servicio', 'detalle' => $e['message']]);
        }

    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Datos incompletos']);
    }
}



// ================================
//     ELIMINAR SERVICIO (ESTADO=2)
// ================================
function deleteServicio($id) {
    global $conn;

    $stid = oci_parse($conn, 'BEGIN FIDE_SERVICIOS_ELIMINAR_SP(:id); END;');
    oci_bind_by_name($stid, ":id", $id);

    if (oci_execute($stid)) {
        echo json_encode(['message' => 'Servicio eliminado exitosamente']);
    } else {
        $e = oci_error($stid);
        http_response_code(500);
        echo json_encode(['error' => 'Error al eliminar servicio', 'detalle' => $e['message']]);
    }
}
