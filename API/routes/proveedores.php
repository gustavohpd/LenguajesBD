<?php
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../src/Database.php';

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
    exit;
}


/* ============================================================
   LISTAR PROVEEDORES
   ============================================================ */
function getProveedores() {
    global $conn;

    $sql = 'BEGIN FIDE_ANGELUS_ESTETICA_PKG.FIDE_PROVEEDORES_LISTAR_SP(:cursor); END;';
    $stid = oci_parse($conn, $sql);

    $cursor = oci_new_cursor($conn);
    oci_bind_by_name($stid, ":cursor", $cursor, -1, SQLT_RSET);

    oci_execute($stid);
    oci_execute($cursor);

    $proveedores = [];

    while ($row = oci_fetch_array($cursor, OCI_ASSOC+OCI_RETURN_NULLS)) {
        $row = array_change_key_case($row, CASE_LOWER);

        foreach ($row as $key => $value) {
            if ($value instanceof OCI_Lob) {
                $row[$key] = $value->read($value->size());
            }
            if (is_string($row[$key])) {
                $row[$key] = utf8_encode($row[$key]);
            }
        }

        $proveedores[] = $row;
    }

    echo json_encode($proveedores, JSON_UNESCAPED_UNICODE);
}


/* ============================================================
   OBTENER PROVEEDOR POR ID
   ============================================================ */
function getProveedorById($id) {
    global $conn;

    $sql = 'BEGIN FIDE_ANGELUS_ESTETICA_PKG.FIDE_PROVEEDORES_OBTENER_SP(:p_id, :cursor); END;';
    $stid = oci_parse($conn, $sql);

    $cursor = oci_new_cursor($conn);

    oci_bind_by_name($stid, ':p_id', $id);
    oci_bind_by_name($stid, ':cursor', $cursor, -1, SQLT_RSET);

    oci_execute($stid);
    oci_execute($cursor);

    $row = oci_fetch_array($cursor, OCI_ASSOC + OCI_RETURN_NULLS);

    if (!$row) {
        http_response_code(404);
        echo json_encode(['error' => 'Proveedor no encontrado']);
        return;
    }

    foreach ($row as $key => $value) {
        if ($value instanceof OCI_Lob)
            $row[$key] = $value->read($value->size());

        if (is_string($row[$key]))
            $row[$key] = utf8_encode($row[$key]);
    }

    $row = array_change_key_case($row, CASE_LOWER);
    echo json_encode($row, JSON_UNESCAPED_UNICODE);
}




/* ============================================================
   CREAR PROVEEDOR
   ============================================================ */
function createProveedor() {
    global $conn;
    $input = json_decode(file_get_contents("php://input"), true);

    if (
        isset($input['proveedor_id'],
              $input['telefono_id'],
              $input['nombre'])
    ) {
        $proveedor_id = $input['proveedor_id'];
        $estado_id    = $input['estado_id'] ?? 1;
        $telefono_id  = $input['telefono_id'];
        $nombre       = $input['nombre'];
        $contacto     = $input['contacto'] ?? "";

        $stid = oci_parse($conn, '
            BEGIN 
              FIDE_ANGELUS_ESTETICA_PKG.FIDE_PROVEEDORES_INSERTAR_SP(
                :proveedor_id,
                :estado_id,
                :telefono_id,
                :nombre,
                :contacto
              );
            END;
        ');

        oci_bind_by_name($stid, ":proveedor_id", $proveedor_id);
        oci_bind_by_name($stid, ":estado_id",    $estado_id);
        oci_bind_by_name($stid, ":telefono_id",  $telefono_id);
        oci_bind_by_name($stid, ":nombre",       $nombre);
        oci_bind_by_name($stid, ":contacto",     $contacto);

        if (oci_execute($stid)) {
            oci_commit($conn);
            echo json_encode(['message' => 'Proveedor creado exitosamente']);
        } else {
            $e = oci_error($stid);
            http_response_code(500);
            echo json_encode(['error' => 'Error al crear proveedor', 'detalle' => $e['message']]);
        }

    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Datos incompletos']);
    }
}



/* ============================================================
   ACTUALIZAR PROVEEDOR
   ============================================================ */
function updateProveedor($id) {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);

    if (
        isset($input['estado_id'],
              $input['telefono_id'],
              $input['nombre'])
    ) {
        $estado_id   = $input['estado_id'];
        $telefono_id = $input['telefono_id'];
        $nombre      = $input['nombre'];
        $contacto    = $input['contacto'] ?? "";

        $stid = oci_parse($conn, '
            BEGIN 
              FIDE_ANGELUS_ESTETICA_PKG.FIDE_PROVEEDORES_MODIFICAR_SP(
                :proveedor_id,
                :estado_id,
                :telefono_id,
                :nombre,
                :contacto
              );
            END;
        ');

        oci_bind_by_name($stid, ":proveedor_id", $id);
        oci_bind_by_name($stid, ":estado_id",    $estado_id);
        oci_bind_by_name($stid, ":telefono_id",  $telefono_id);
        oci_bind_by_name($stid, ":nombre",       $nombre);
        oci_bind_by_name($stid, ":contacto",     $contacto);

        if (oci_execute($stid)) {
            oci_commit($conn);
            echo json_encode(['message' => 'Proveedor actualizado exitosamente']);
        } else {
            $e = oci_error($stid);
            http_response_code(500);
            echo json_encode(['error' => 'Error al actualizar proveedor', 'detalle' => $e['message']]);
        }

    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Datos incompletos']);
    }
}



/* ============================================================
   ELIMINAR PROVEEDOR (soft delete)
   ============================================================ */
function deleteProveedor($id) {
    global $conn;

    $stid = oci_parse($conn, '
        BEGIN 
          FIDE_ANGELUS_ESTETICA_PKG.FIDE_PROVEEDORES_ELIMINAR_SP(:id);
        END;
    ');

    oci_bind_by_name($stid, ":id", $id, -1, SQLT_INT);

    if (oci_execute($stid)) {
        oci_commit($conn);
        echo json_encode(['message' => 'Proveedor eliminado (estado=2)']);
    } else {
        $e = oci_error($stid);
        http_response_code(500);
        echo json_encode(['error' => 'Error al eliminar proveedor', 'detalle' => $e['message']]);
    }
}
