<?
$base = array("name" => "Rocket Skates", "price" => 12.75, "color" => "yellow");
$update = array("price" => 15.25, "color" => "red", "year" => 1974);

$result = array_merge($base, $update);
print_r($result);
?>
