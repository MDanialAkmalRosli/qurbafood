<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/crimsonw/public_html/s273046/qurbafood/php/PHPMailer/src/Exception.php';
require '/home8/crimsonw/public_html/s273046/qurbafood/php/PHPMailer/src/PHPMailer.php';
require '/home8/crimsonw/public_html/s273046/qurbafood/php/PHPMailer/src/SMTP.php';

include_once("dbconnect.php");

$email = $_POST['email'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(1000,9999);

$sqlregister = "INSERT INTO tbl_user(user_email,password,otp) VALUES ('$email','$passha1','$otp')";
if($conn-> query($sqlregister) === TRUE){
    echo "SUCCESS";
    sendEmail($otp, $email);
}
else{
    echo "Failed";
}

function sendEmail($otp,$email){
     $mail = new PHPMailer(true);
     $mail->SMTPDebug = 0;                                       //Disable verbose debug output
     $mail->isSMTP();                                            //Send using SMTP
     $mail->Host       = 'mail.crimsonwebs.com';                 //Set the SMTP server to send through
     $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
     $mail->Username   = 'qurbafood@crimsonwebs.com';        //SMTP username
     $mail->Password   = '~mPr6=K[;qgG';                         //SMTP password
     $mail->SMTPSecure = 'tls';         
     $mail->Port       = 587;
    
     $from = "qurbafood@crimsonwebs.com";
     $to = $email;
     $subject = "From Qurbafood Admin.";
     $message = "<p>Click the following link to verify your account<br><br><a href='https://crimsonwebs.com/s273046/qurbafood/php/verify_account.php?email=".$email."&key=".$otp."'>Click Here to verify your account</a>";
    
     $mail->setFrom($from,"qurbafood");
     $mail->addAddress($to);
    
     $mail->isHTML(true);                    //Set email format to HTML
     $mail->Subject = $subject;
     $mail->Body    = $message;
     $mail->send();
    }

?>