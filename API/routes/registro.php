<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../src/Database.php';

function registrarUsuario() {
    try {

        $db = new Database([
            'DB_USER' => 'ANGELUS_ESTETICA',
            'DB_PASS' => 'ag123',
            'DB_HOST' => 'localhost',
            'DB_PORT' => '1521',
            'DB_SERVICE' => 'xe'
        ]);
        $conn = $db->getConnection();

        $data = json_decode(file_get_contents("php://input"), true);

        if (
            empty($data["nombre"]) ||
            empty($data["apellido_paterno"]) ||
            empty($data["correo"]) ||
            empty($data["telefono"]) ||
            empty($data["password"])
        ) {
            http_response_code(400);
            echo json_encode([
                "status" => "error",
                "message" => "Faltan datos obligatorios."
            ]);
            return;
        }

        $sql = "BEGIN FIDE_ANGELUS_ESTETICA_PKG.FIDE_USUARIOS_REGISTRAR_SP(
                    :p_nombre,
                    :p_apellido_paterno,
                    :p_apellido_materno,
                    :p_correo,
                    :p_telefono,
                    :p_password,
                    :p_usuario_id,
                    :p_cliente_id
                ); END;";

        $stmt = oci_parse($conn, $sql);

        oci_bind_by_name($stmt, ":p_nombre",            $data["nombre"]);
        oci_bind_by_name($stmt, ":p_apellido_paterno",  $data["apellido_paterno"]);
        oci_bind_by_name($stmt, ":p_apellido_materno",  $data["apellido_materno"]);
        oci_bind_by_name($stmt, ":p_correo",            $data["correo"]);
        oci_bind_by_name($stmt, ":p_telefono",          $data["telefono"]);
        oci_bind_by_name($stmt, ":p_password",          $data["password"]);

        oci_bind_by_name($stmt, ":p_usuario_id", $usuario_id, 40);
        oci_bind_by_name($stmt, ":p_cliente_id", $cliente_id, 40);

        oci_execute($stmt);

        echo json_encode([
            "status"     => "success",
            "usuario_id" => $usuario_id,
            "cliente_id" => $cliente_id
        ]);

    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode([
            "status"  => "error",
            "message" => $e->getMessage()
        ]);
    }
}
