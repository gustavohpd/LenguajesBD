<?php
class Database {
    private $conn;
    private $type;

    public function __construct($cfg = []) {

        // CONFIG
        $user    = $cfg['DB_USER']    ?? 'ANGELUS_ESTETICA';
        $pass    = $cfg['DB_PASS']    ?? 'ag123';
        $host    = $cfg['DB_HOST']    ?? 'localhost';
        $port    = $cfg['DB_PORT']    ?? '1521';
        $service = $cfg['DB_SERVICE'] ?? 'xe';

        $forceOci = $cfg['force_oci'] ?? false;

        $tns = "//{$host}:{$port}/{$service}";

        // ================================
        // ✔ FORZAR OCI (solo pago.php)
        // ================================
        if ($forceOci === true) {
            $this->connectOCI($user, $pass, $tns);
            return;
        }

        // ================================
        // ✔ INTENTAR PDO PRIMERO
        // ================================
        try {
            $dsn = "oci:dbname={$tns};charset=AL32UTF8";

            $this->conn = new PDO($dsn, $user, $pass, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
            ]);

            $this->type = 'pdo';
            return;

        } catch (Exception $e) {
            // Si PDO falla, continuar a OCI8
        }

        // ================================
        // ✔ FALLBACK A OCI8
        // ================================
        $this->connectOCI($user, $pass, $tns);
    }

    private function connectOCI($user, $pass, $tns)
    {
        $this->conn = oci_connect($user, $pass, $tns);

        if (!$this->conn) {
            $err = oci_error();
            throw new Exception("OCI8 ERROR: " . $err['message']);
        }

        $this->type = 'oci';
    }

    public function getConnection() {
        return $this->conn;
    }

    public function getType() {
        return $this->type;
    }
}
