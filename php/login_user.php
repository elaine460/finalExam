<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM tbl_users WHERE user_email = '$email' AND user_password = '$password'";
$result = $conn->query($sqllogin);
$numrow = $result->num_rows;

if ($numrow > 0) {
    while ($row = $result->fetch_assoc()) {
        $userlist['id'] = $row['user_id'];
        $userlist['email'] = $row['user_email'];
        $userlist['password'] = $row['user_password'];
        $userlist['name'] = $row['user_name'];
        $userlist['phone'] = $row['user_phone'];
        $userlist['address'] = $row['user_address'];
    }
    $sqlgetqty = "SELECT * FROM tbl_cart WHERE cart_status IS NULL";
    $result = $conn->query($sqlgetqty);
    $number_of_result = $result->num_rows;
    $carttotal = 0;
    while($row = $result->fetch_assoc()) {
        $carttotal = $row['cart_qty'] + $carttotal;
    }
    $mycart = array();
    $userlist['cart'] =$carttotal;

    $response = array('status' => 'success', 'data' => $userlist);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>


