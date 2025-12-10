<?php
header('Content-Type: application/json; charset=utf-8');

try {
    $db = new Database();

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
   LISTAR CITAS
   ============================================================ */
function getCitas() {
    global $conn;
    $sql = 'BEGIN FIDE_ANGELUS_ESTETICA_PKG.FIDE_CITAS_LISTAR_SP(:cursor); END;';
    $stid = oci_parse($conn, $sql);
    $cursor = oci_new_cursor($conn);
    oci_bind_by_name($stid, ":cursor", $cursor, -1, SQLT_RSET);
    oci_execute($stid);
    oci_execute($cursor);

    $citas = [];
    while ($row = oci_fetch_array($cursor, OCI_ASSOC + OCI_RETURN_NULLS)) {
        $row = array_change_key_case($row, CASE_LOWER);
        foreach ($row as $key => $value) {
            if ($value instanceof OCI_Lob) $row[$key] = $value->read($value->size());
            if ($value instanceof DateTime) $row[$key] = $value->format('Y-m-d H:i:s');
            if (is_string($value)) $row[$key] = utf8_encode($value);
        }
        $citas[] = $row;
    }
    echo json_encode($citas, JSON_UNESCAPED_UNICODE);
}

/* ============================================================
   OBTENER CITA POR ID
   ============================================================ */
function getCitaById($cita_id) {
    global $conn;
    $sql = 'BEGIN FIDE_ANGELUS_ESTETICA_PKG.FIDE_CITAS_OBTENER_SP(:p_cita_id, :cursor); END;';
    $stid = oci_parse($conn, $sql);
    $cursor = oci_new_cursor($conn);
    oci_bind_by_name($stid, ':p_cita_id', $cita_id);
    oci_bind_by_name($stid, ':cursor', $cursor, -1, SQLT_RSET);
    oci_execute($stid);
    oci_execute($cursor);

    $row = oci_fetch_array($cursor, OCI_ASSOC + OCI_RETURN_NULLS);
    if (!$row) {
        http_response_code(404);
        echo json_encode(['error' => 'Cita no encontrada']);
        return;
    }
    $row = array_change_key_case($row, CASE_LOWER);
    echo json_encode($row, JSON_UNESCAPED_UNICODE);
}

/* ============================================================
   CREAR CITA
   ============================================================ */
function createCita() {
    global $conn;
    $input = json_decode(file_get_contents("php://input"), true);
    if (!isset($input['cliente_id'], $input['servicio_id'], $input['fecha_hora'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Datos incompletos']);
        return;
    }

    $cliente_id  = intval($input['cliente_id']);
    $servicio_id = intval($input['servicio_id']);
    $estado_id   = isset($input['estado_id']) ? intval($input['estado_id']) : 1;
    $fecha_hora  = $input['fecha_hora']; // formato "YYYY-MM-DD HH:mm:ss"
    $notas       = $input['notas'] ?? null;

    
    $stid = oci_parse($conn, "
        BEGIN 
        FIDE_ANGELUS_ESTETICA_PKG.FIDE_CITAS_INSERTAR_SP(
            :cliente_id, :servicio_id, :estado_id, TO_TIMESTAMP(:fecha_hora, 'YYYY-MM-DD HH24:MI:SS'), :notas
        );
        END;");
    oci_bind_by_name($stid, ":cliente_id",  $cliente_id);
    oci_bind_by_name($stid, ":servicio_id", $servicio_id);
    oci_bind_by_name($stid, ":estado_id",   $estado_id);
    oci_bind_by_name($stid, ":fecha_hora",  $fecha_hora);
    oci_bind_by_name($stid, ":notas",       $notas, 4000);

    if (oci_execute($stid)) {
        oci_commit($conn);
        echo json_encode(['message' => 'Cita creada exitosamente']);
  } else {
    $e = oci_error($stid);

    http_response_code(500);

    echo json_encode([
        'error' => 'Error al crear cita',
        'detalle' => $e['message']
    ]);
}
}
/* ============================================================
   ACTUALIZAR CITA
   ============================================================ */
function updateCita($id) {
    global $conn;
    $input = json_decode(file_get_contents("php://input"), true);
    if (!isset($input['estado_id'], $input['fecha_hora'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Datos incompletos']);
        return;
    }

    $cita_id    = intval($id);
    $estado_id  = intval($input['estado_id']);
    $fecha_hora = $input['fecha_hora'];
    $notas      = $input['notas'] ?? null;

    $stid = oci_parse($conn, "
        BEGIN 
          FIDE_ANGELUS_ESTETICA_PKG.FIDE_CITAS_MODIFICAR_SP(
            :cita_id, :estado_id, TO_TIMESTAMP(:fecha_hora, ''YYYY-MM-DD HH24:MI:SS''), :notas
          ); 
        END;");
    oci_bind_by_name($stid, ":cita_id",    $cita_id);
    oci_bind_by_name($stid, ":estado_id",  $estado_id);
    oci_bind_by_name($stid, ":fecha_hora", $fecha_hora);
    oci_bind_by_name($stid, ":notas",      $notas, 4000);

    if (oci_execute($stid)) {
        oci_commit($conn);
        echo json_encode(['message' => 'Cita actualizada exitosamente']);
    } else {
        $e = oci_error($stid);
        http_response_code(500);
        echo json_encode(['error' => 'Error al actualizar cita', 'detalle' => $e['message']]);
    }
}

/* ============================================================
   ELIMINAR CITA (soft delete)
   ============================================================ */
function deleteCita($id) {
    global $conn;
    $stid = oci_parse($conn, 'BEGIN FIDE_ANGELUS_ESTETICA_PKG.FIDE_CITAS_ELIMINAR_SP(:id); END;');
    oci_bind_by_name($stid, ":id", $id, -1, SQLT_INT);

    if (oci_execute($stid)) {
        oci_commit($conn);
        echo json_encode(['message' => 'Cita eliminada (estado=2)', 'cita_id' => $id]);
    } else {
        $e = oci_error($stid);
        http_response_code(500);
        echo json_encode(['error' => 'Error al eliminar cita', 'detalle' => $e['message']]);
    }
}