<?php

require_once __DIR__ . '/../src/Database.php';

function procesarPago() {

    $db = new Database([
        'DB_USER'    => 'ANGELUS_ESTETICA',
        'DB_PASS'    => 'ag123',
        'DB_HOST'    => 'localhost',
        'DB_PORT'    => '1521',
        'DB_SERVICE' => 'xe'
    ]);

    $conn = $db->getConnection();

    $input = json_decode(file_get_contents("php://input"), true);

    if (!$input["cliente_id"] || !$input["metodo_pago_id"] || !$input["carrito"]) {
        http_response_code(400);
        echo json_encode(["error" => "Datos incompletos"]);
        return;
    }

    $cliente_id     = $input["cliente_id"];
    $metodo_pago_id = $input["metodo_pago_id"];
    $carrito        = $input["carrito"];

    //  LOG PARA SABER QUÉ PRODUCTOS ESTÁN LLEGANDO AL BACKEND
    error_log("=== CARRITO RECIBIDO EN BACKEND ===");
    error_log(json_encode($carrito, JSON_PRETTY_PRINT));

    // Esto es lo que se envía al SP (en JSON)
    $json_items = json_encode($carrito);

    $sql = "
        BEGIN 
            FIDE_ANGELUS_ESTETICA_PKG.FIDE_PAGO_PROCESAR_SP(
                :p_cliente_id,
                :p_metodo_pago_id,
                :p_items_json,
                :p_factura_id
            );
        END;
    ";

    $stid = oci_parse($conn, $sql);

    oci_bind_by_name($stid, ":p_cliente_id",     $cliente_id);
    oci_bind_by_name($stid, ":p_metodo_pago_id", $metodo_pago_id);
    oci_bind_by_name($stid, ":p_items_json",     $json_items);
    oci_bind_by_name($stid, ":p_factura_id",     $factura_id, 40);

    if (!oci_execute($stid)) {
        $e = oci_error($stid);
        http_response_code(500);

        error_log("=== ERROR ORACLE EN EL SP ===");
        error_log($e["message"]);

        echo json_encode(["error" => $e["message"]]);
        return;
    }

    echo json_encode([
        "success"    => true,
        "factura_id" => $factura_id
    ]);
}
