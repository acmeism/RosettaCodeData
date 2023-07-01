<?
$base = array("name" => "Rocket Skates", "price" => 12.75, "color" => "yellow");
$update = array("price" => 15.25, "color" => "red", "year" => 1974);

$result = $update + $base; // Notice that the order is reversed
print_r($result);
?>
