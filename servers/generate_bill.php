<?php
error_reporting(0);
//include_once("dbconnect.php");

$email = $_GET['email'];
$mobile = $_GET['mobile'];
$name = $_GET['name']; 
$amount = $_GET['amount']; 

$api_key = '011f5153-87e8-475e-904f-8b34f0b34744';                              // fill own API key
$collection_id = 'mn9l6_7i';                                                    // fill own collection ID
$host = 'https://billplz-staging.herokuapp.com/api/v3/bills';   

$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'mobile' => $mobile,
          'name' => $name,
          'amount' => $amount * 100, // RM20
		  'description' => 'Payment for order' ,
          'callback_url' => "https://crimsonwebs.com/s273046/qurbafood/php/return_url",     
          'redirect_url' => "https://crimsonwebs.com/s273046/qurbafood/php/payment_update.php?email=$email&name=name&mobile=$mobile&amount=$amount"      // belum ada lagi
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

echo "<pre>".print_r($bill, true)."</pre>";
header("Location: {$bill['url']}");
?>