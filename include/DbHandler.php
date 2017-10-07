<?php

/**
 * Class to handle all db operations
 * This class will have CRUD methods for database tables
 *
 * @author Ravi Tamada
 * @link URL Tutorial link
 */
class DbHandler {

    private $conn;

    function __construct() {
        require_once dirname(__FILE__) . '/DbConnect.php';
        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();
    }

    public function doLogin($usuario, $password, $tipo) {
        $stmt = $this->conn->prepare("SELECT idusuario, nombre FROM usuario WHERE usuario = ? AND password = ? AND tipo = ?");
        $stmt->bind_param("sss", $usuario, $password, $tipo);

        if ($stmt->execute()) {

            $res = array();
            $stmt->bind_result($idusuario, $nombre);
            $stmt->store_result();
            $stmt->fetch();

            if ($stmt->num_rows > 0) {
                $res["idusuario"] = $idusuario;
                $res["nombre"] = $nombre;
                $stmt->close();
                return $res;
            } else {
                $stmt->close();
                return NULL;
            }

        } else {
            $stmt->close();
            return NULL;
        }
    }

    public function getAllEspecialidades() {
        $stmt = $this->conn->prepare("SELECT idespecialidad, descripcion FROM especialidad");
        $stmt->execute();
        $tasks = $stmt->get_result();
        $stmt->close();
        return $tasks;
    }

    public function getEspecialistas($idespecialidad) {
        $stmt = $this->conn->prepare("SELECT u.idusuario,	u.nombre FROM usuario u, usuario_especialidad ue, especialidad e WHERE u.idusuario = ue.idusuario AND ue.idespecialidad = e.idespecialidad AND e.idespecialidad = ?");
        $stmt->execute();
        $tasks = $stmt->get_result();
        $stmt->close();
        return $tasks;
    }

}

?>
