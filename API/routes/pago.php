<?php

require_once __DIR__ . '/../src/Database.php';

/* ===========================================================
   PROCESAR PAGO — LLAMA AL SP FIDE_PAGO_PROCESAR_SP
   =========================================================== */
function procesarPago() {

    // Crear conexión SOLO cuando se llama la función
    $db = new Database([
        'DB_USER' => 'ANGELUS_ESTETICA',
        'DB_PASS' => 'ag123',
        'DB_HOST' => 'localhost',
        'DB_PORT' => '1521',
        'DB_SERVICE' => 'xe'
    ]);

    $conn = $db->getConnection();

    $input = json_decode(file_get_contents("php://input"), true);

    if (!isset($input["cliente_id"], $input["metodo_pago_id"], $input["carrito"])) {
        http_response_code(400);
        echo json_encode(["error" => "Datos incompletos"]);
        return;
    }

    $cliente_id     = $input["cliente_id"];
    $metodo_pago_id = $input["metodo_pago_id"];
    $carrito        = $input["carrito"];

    // Crear colección Oracle
    $collection = oci_new_collection($conn, "T_TABLA_CARRITO");

    foreach ($carrito as $item) {
        $obj = oci_new_object($conn, "T_ITEM_CARRITO");
        $obj->PRODUCTO_ID = $item["producto_id"];
        $obj->CANTIDAD    = $item["cantidad"];
        $obj->PRECIO      = $item["precio"];
        $collection->append($obj);
    }

    // Llamar SP
    $sql = "
        BEGIN 
            FIDE_ANGELUS_ESTETICA_PKG.FIDE_PAGO_PROCESAR_SP(
                :p_cliente_id,
                :p_metodo_pago_id,
                :p_items,
                :p_factura_id
            );
        END;
    ";

    $stid = oci_parse($conn, $sql);

    oci_bind_by_name($stid, ":p_cliente_id",     $cliente_id);
    oci_bind_by_name($stid, ":p_metodo_pago_id", $metodo_pago_id);
    oci_bind_by_name($stid, ":p_items",          $collection, -1, SQLT_NTY);
    oci_bind_by_name($stid, ":p_factura_id",     $factura_id, 40, SQLT_INT);

    if (!oci_execute($stid)) {
        $e = oci_error($stid);
        http_response_code(500);
        echo json_encode([
            "error"   => "Error al procesar pago",
            "detalle" => $e["message"]
        ]);
        return;
    }

    echo json_encode([
        "success"     => true,
        "factura_id"  => $factura_id,
        "message" => "Pago procesado exitosamente"
    ]);
}


