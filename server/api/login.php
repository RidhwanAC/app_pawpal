<?php

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!isset($_POST['email']) || !isset($_POST['password'])) {
        $response = array('status' => 'failed', 'message' => 'Bad Request.');
        sendJsonResponse($response);
        exit();
    }

    try {
        include 'dbconnect.php';
    } catch (\Throwable $th) {
        $response = array('status' => 'failed', 'message' => 'Database connection failed.');
        sendJsonResponse($response);
        exit();
    }

    $email = $_POST['email'];
    $password = $_POST['password'];
    $hashedpassword = sha1($password);
    
    $sqllogin = "SELECT * FROM `tbl_users` WHERE `email` = '$email' AND `password` = '$hashedpassword'";
    $result = $conn->query($sqllogin);
    if ($result->num_rows > 0) {
        $userdata = array();
        while ($row = $result->fetch_assoc()) {
            $userdata[] = $row;
        }
        $response = array('status' => 'success', 'message' => 'Login successful.', 'data' => $userdata);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'User Not Found.','data'=>null);
        sendJsonResponse($response);
    }

}else{
    $response = array('status' => 'failed', 'message' => 'Method Not Allowed.');
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($response)
{
    header('Content-Type: application/json');
    echo json_encode($response);
}

?>