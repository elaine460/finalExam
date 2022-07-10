<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$sqlloadtutor = "SELECT tbl_tutors.tutor_id, tbl_tutors.tutor_email, tbl_tutors.tutor_phone, tbl_tutors.tutor_name,
 tbl_tutors.tutor_password, tbl_tutors.tutor_description, tbl_tutors.tutor_datereg, tbl_subjects.subject_name, tbl_subjects.subject_price, 
 tbl_subjects.subject_id, tbl_subjects.subject_sessions, tbl_subjects.subject_description, tbl_subjects.subject_rating 
 FROM tbl_tutors INNER JOIN tbl_subjects ON tbl_tutors.tutor_id = tbl_subjects.tutor_id";

$results_per_page = 5;
$pageno = (int)$_POST['pageno'];

$page_first_result = ($pageno - 1) * $results_per_page;

$result = $conn->query($sqlloadtutor);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadtutor = $sqlloadtutor . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloadtutor);
if ($result->num_rows > 0) {
    //do something
    $tutors["tutors"] = array();
    while ($row = $result->fetch_assoc()) {
        $ttlist = array();
        $ttlist['tutor_id'] = $row['tutor_id'];
        $ttlist['tutor_email'] = $row['tutor_email'];
        $ttlist['tutor_phone'] = $row['tutor_phone'];
        $ttlist['tutor_name'] = $row['tutor_name'];
        $ttlist['tutor_password'] = $row['tutor_password'];
        $ttlist['tutor_description'] = $row['tutor_description'];
        $ttlist['tutor_datereg'] = $row['tutor_datereg'];
        $ttlist['subject_id'] = $row['subject_id'];
        $ttlist['subject_name'] = $row['subject_name'];
        $ttlist['subject_description'] = $row['subject_description'];
        $ttlist['subject_sessions'] = $row['subject_sessions'];
        $ttlist['subject_rating'] = $row['subject_rating'];
        $ttprice = $row['subject_price'];
        $ttlist['subject_price'] = number_format((float)$ttprice, 2, '.', '');
        array_push($tutors["tutors"],$ttlist);
    }
    $response = array('status' => 'success', 'pageno'=>"$pageno",'numofpage'=>"$number_of_page", 'data' => $tutors);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'pageno'=>"$pageno",'numofpage'=>"$number_of_page",'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

