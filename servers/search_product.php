<?php

include_once("dbconnect.php");
$prname = $_POST['prname'];

if (isset($prname)) {
    $searchitems = "SELECT * FROM tbl_products WHERE prname LIKE '%$prname%' ";
} 
else {
    $searchitems = "SELECT * FROM tbl_products ORDER BY date_added DESC";
}

$result = $conn-> query($searchitems);

if($result->num_rows > 0){
    $response["products"] = array();
    while ($row = $result -> fetch_assoc()){
        $prodlist = array();
        $prodlist[prid] = $row['prid'];
        $prodlist[prname] = $row['prname'];
        $prodlist[prtype] = $row['prtype'];
        $prodlist[prprice] = $row['prprice'];
        $prodlist[prqty] = $row['prqty'];
        array_push($response["products"], $prodlist);
    }
    echo json_encode($response);
}
else {
    echo "no data";  }

?>