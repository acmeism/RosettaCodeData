<?php

$factor = bcpow(2, 64);
$product = bcmul($factor, $factor);
echo "2^64 * 2^64 is " . $product;
?>
