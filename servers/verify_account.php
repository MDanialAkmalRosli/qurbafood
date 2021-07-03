<?php
    error_reporting(0);
    include_once("dbconnect.php");
    $email = $_GET['email'];
    $otp = $_GET['key'];
    
    $sql = "SELECT * FROM tbl_user WHERE user_email = '$email' AND otp = '$otp'";
    $result = $conn->query($sql);
    if ($result->num_rows > 0){
        $sql_update = "UPDATE tbl_user SET otp = '123' WHERE user_email = '$email' AND otp = '$otp'";
        if ($conn->query($sql_update) === TRUE){
            echo 'success';
        } else { 
            echo 'failed';
        }
    } else{
        echo "failed";
    }

?>      