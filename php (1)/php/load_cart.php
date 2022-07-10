<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = $_POST['user_email'];
$sqlloadcart = "SELECT tbl_cart.cart_id, tbl_cart.subject_id, tbl_cart.user_email, tbl_cart.cart_qty, tbl_subjects.subject_name, tbl_subjects.subject_price, tbl_subjects.subject_sessions FROM tbl_cart INNER JOIN tbl_subjects ON tbl_cart.subject_id = tbl_subjects.subject_id WHERE tbl_cart.user_email = $email AND tbl_cart.cart_status IS NULL";
$result = $conn->query($sqlloadcart);
$number_of_result = $result->num_rows;
if ($result->num_rows > 0) {
    //do something
    $total_payable = 0;
    $carts["cart"] = array();
    while ($rows = $result->fetch_assoc()) {
        
        $sjlist = array();
        $sjlist['cartid'] = $rows['cart_id'];
        $sjlist['sjname'] = $rows['subject_name'];
        $sjprice = $rows['subject_price'];
        $sjlist['sjqty'] = $rows['subject_sessions'];
        $sjlist['price'] = number_format((float)$sjprice, 2, '.', '');
        $sjlist['cartqty'] = $rows['cart_qty'];
        $sjlist['sjid'] = $rows['subject_id'];
        $price = $rows['cart_qty'] * $sjprice;
        $total_payable = $total_payable + $price;
        $sjlist['pricetotal'] = number_format((float)$price, 2, '.', ''); 
        array_push($carts["cart"],$sjlist);
    }
    $response = array('status' => 'success', 'data' => $carts, 'total' => $total_payable);
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