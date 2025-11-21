<?php
class Database {
    private $conn;

    public function __construct($cfg = []) {
        // lee .env o recibe $cfg
        $user = $cfg['DB_USER'] ?? 'TAREA1';
        $pass = $cfg['DB_PASS'] ?? 'Tarea123';
        $host = $cfg['DB_HOST'] ?? 'localhost';
        $port = $cfg['DB_PORT'] ?? '1521';
        $service = $cfg['DB_SERVICE'] ?? 'xe';

        $tns = "//{$host}:{$port}/{$service}";

        // Intentar con PDO si está disponible
        try {
            $dsn = "oci:dbname={$tns};charset=AL32UTF8";
            $this->conn = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
            $this->type = 'pdo';
        } catch (Exception $e) {
            // fallback a OCI8
            $this->conn = oci_connect($user, $pass, $tns);
            if (!$this->conn) {
                $err = oci_error();
                throw new Exception("No se pudo conectar (OCI8 fallback): " . $err['message']);
            }
            $this->type = 'oci';
        }
    }

    public function getConnection() {
        return $this->conn;
    }

    public function getType() {
        return $this->type;
    }
}
