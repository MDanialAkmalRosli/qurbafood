<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(1000,9999);
$status = "active";

$sqlregister = "INSERT INTO tbl_user(user_email,password,otp,status) VALUES ('$email','$passha1','$otp','$status')";
if($conn-> query($sqlregister) === TRUE){
    sendEmail($otp, $email);
    echo "SUCCESS";
}
else{
    echo "Failed";
}

function sendEmail($otp,$email){
    $from = "QurbaFood Administrator";
    $to = $email;
    $subject = "From QurbaFood. Please verify your account.";
    $message = "Use the following link to verify your account: "."\n https://crimsonwebs.com/s273046/qurbafood/php/verify_account.php?email=".$email."&key=".$otp;
    $headers = "From: " . $from;
    mail($email,$subject,$message,$headers);
}

?>
