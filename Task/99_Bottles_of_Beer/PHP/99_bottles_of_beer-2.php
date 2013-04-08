<?php
foreach(range(99,1) as $i) {
    $p = ($i>1)?"s":"";
    echo <<< EOV
$i bottle$p of beer on the wall
$i bottle$p of beer
Take one down, pass it around


EOV;
}
echo "No more Bottles of beer on the wall";
?>
