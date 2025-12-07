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
    exit;
}

/* ===========================================================
   LOGIN DE USUARIO
   =========================================================== */
function loginUsuario() {
    global $conn;

    $input = json_decode(file_get_contents("php://input"), true);

    if (!isset($input['correo']) || !isset($input['password'])) {
        http_response_code(400);
        echo json_encode(["error" => "Faltan datos"]);
        return;
    }

    $correo   = $input['correo'];
    $password = $input['password'];

    $sql = 'BEGIN FIDE_ANGELUS_ESTETICA_PKG.FIDE_USUARIOS_LOGIN_SP(
                :p_correo,
                :p_password,
                :cursor
            ); END;';

    $stid = oci_parse($conn, $sql);

    $cursor = oci_new_cursor($conn);

    oci_bind_by_name($stid, ":p_correo",   $correo);
    oci_bind_by_name($stid, ":p_password", $password);
    oci_bind_by_name($stid, ":cursor",     $cursor, -1, SQLT_RSET);

    oci_execute($stid);
    oci_execute($cursor);

    $row = oci_fetch_array($cursor, OCI_ASSOC + OCI_RETURN_NULLS);

    if (!$row) {
        echo json_encode([
            "success" => false,
            "message" => "Credenciales incorrectas"
        ]);
        return;
    }

    // Convertir claves a minúsculas
    $row = array_change_key_case($row, CASE_LOWER);

    echo json_encode([
        "success"    => true,
        "usuario_id" => $row["usuario_id"],
        "rol_id"     => $row["rol_id"],
        "cliente_id" => $row["cliente_id"],
"nombre" => utf8_encode($row["nombre"]),
        "correo"     => $row["correo"]
    ], JSON_UNESCAPED_UNICODE);
}
