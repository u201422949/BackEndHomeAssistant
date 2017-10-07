<?php

require_once '../include/DbHandler.php';
require_once '../include/PassHash.php';
require '.././libs/Slim/Slim.php';

\Slim\Slim::registerAutoloader();

$app = new \Slim\Slim();

/**
 * Login de usuario
 * url - /login
 * method - POST
 * params - usuario, clave
 */
$app->post('/login', function () use ($app) {

    $response = array();

    // reading body
    $data = getData($app);

    // reading post params
    $usuario = $data["usuario"];
    $password = $data["password"];
    $tipo = $data["tipo"];

    $db = new DbHandler();

    $result = $db->doLogin($usuario, $password, $tipo);

    if ($result != NULL) {
        $response["error"] = false;
        $response["idusuario"] = $result["idusuario"];
        $response["nombre"] = $result["nombre"];
        echoResponse(200, $response);
    } else {
        $response["error"] = true;
        $response["message"] = "Usuario y/o contraseña inválida.";
        echoResponse(404, $response);
    }
});

$app->post('/especialidades', function () use ($app) {

    $response = array();

    $db = new DbHandler();

    $result = $db->getAllEspecialidades();

    $response["error"] = false;
    $response["especialidades"] = array();

    // looping through result and preparing tasks array
    while ($restaurant = $result->fetch_assoc()) {
        $tmp = array();
        $tmp["idespecialidad"] = $restaurant["idespecialidad"];
        $tmp["descripcion"] = $restaurant["descripcion"];
        array_push($response["especialidades"], $tmp);
    }

    echoResponse(200, $response);
});

$app->post('/especialistas', function () use ($app) {

    $response = array();

    // reading body
    $data = getData($app);

    // reading post params
    $idespecialidad = $data["idespecialidad"];

    $db = new DbHandler();

    $result = $db->getEspecialistas($idespecialidad);

    $response["error"] = false;
    $response["especialidades"] = array();

    // looping through result and preparing tasks array
    while ($restaurant = $result->fetch_assoc()) {
        $tmp = array();
        $tmp["idespecialidad"] = $restaurant["idespecialidad"];
        $tmp["descripcion"] = $restaurant["descripcion"];
        array_push($response["especialidades"], $tmp);
    }

    echoResponse(200, $response);
});

/**
 * Verifying required params posted or not
 */
function verifyRequiredParams($required_fields) {
    $error = false;
    $error_fields = "";
    $request_params = array();
    $request_params = $_REQUEST;
    // Handling PUT request params
    if ($_SERVER['REQUEST_METHOD'] == 'PUT') {
        $app = \Slim\Slim::getInstance();
        parse_str($app->request()->getBody(), $request_params);
    }
    foreach ($required_fields as $field) {
        if (!isset($request_params[$field]) || strlen(trim($request_params[$field])) <= 0) {
            $error = true;
            $error_fields .= $field . ', ';
        }
    }

    if ($error) {
        // Required field(s) are missing or empty
        // echo error json and stop the app
        $response = array();
        $app = \Slim\Slim::getInstance();
        $response["error"] = true;
        $response["message"] = 'Required field(s) ' . substr($error_fields, 0, -2) . ' is missing or empty';
        echoResponse(400, $response);
        $app->stop();
    }
}

/**
 * Echoing json response to client
 * @param String $status_code Http response code
 * @param Int $response Json response
 */
function echoResponse($status_code, $response)
{
    $app = \Slim\Slim::getInstance();
    // Http response code
    $app->status($status_code);

    // setting response content type to json
    $app->contentType('application/json');

    echo json_encode($response);
}

function getData($app) {
    return json_decode($app->request->getBody(), TRUE);
}

$app->run();
?>