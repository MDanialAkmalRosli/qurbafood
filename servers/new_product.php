<?php
include_once("dbconnect.php");
$prid = rand(1000,9999);
$prname= $_POST['prname'];
$prtype = $_POST['prtype'];
$prprice = $_POST['prprice'];
$prqty = $_POST['prqty'];

$sqlinsert = "INSERT INTO tbl_products(prid,prname,prtype,prprice,prqty) VALUE('$prid','$prname','$prtype','$prprice','$prqty')";
if ($conn->query($sqlinsert) === TRUE) {
    echo "You've success"; }
else {
    echo "Failed"; }
?>
