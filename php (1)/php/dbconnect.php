<?php
$servername = "localhost";
$username   = "lewelain_mytutor_user";
$password   = "WkzK,ysAWZkb";
$dbname     = "lewelain_mytutor_db";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>