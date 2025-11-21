<?php
header('Content-Type: application/json; charset=utf-8');

try {
    $db = new Database([
        'DB_USER' => 'TAREA1',
        'DB_PASS' => 'Tarea123',
        'DB_HOST' => 'localhost',
        'DB_PORT' => '1521',
        'DB_SERVICE' => 'xe'
    ]);
    
    if ($db->getType() === 'pdo') {
        $pdo = $db->getConnection();
        //$stmt = $pdo->query("SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME FROM EMPLOYEES WHERE ROWNUM <= 50");
        $stmt = $pdo->query("SELECT * FROM FIDE_CLIENTES_TB");
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($rows);
    } else {
        $conn = $db->getConnection();
        $stid = oci_parse($conn, "SELECT * FROM FIDE_CLIENTES_TB");
        oci_execute($stid);
        $data = [];

        while ($r = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {

            // Normalizar nombres de columnas a minúsculas
            $r = array_change_key_case($r, CASE_LOWER);

            // Convertir LOBs, fechas y utf8
            foreach ($r as $key => $value) {

                if ($value instanceof OCI_Lob) {
                    $r[$key] = $value->read($value->size());
                }

                if ($value instanceof DateTime) {
                    $r[$key] = $value->format('Y-m-d H:i:s');
                }

                if (is_string($value)) {
                    $r[$key] = utf8_encode($value);
                }
            }

            $data[] = $r;
        }

        echo json_encode($data, JSON_UNESCAPED_UNICODE);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}
