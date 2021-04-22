<?php
$servername = "localhost";
$username   = "crimsonw_qurbafoodadmin";
$password   = "Rl#Ip519yPv;";
$dbname     = "crimsonw_qurbafoodDB";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} else {
    echo 'success';
}
?>
