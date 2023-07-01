<?php
$lst = array(array(1), 2, array(array(3, 4), 5), array(array(array())), array(array(array(6))), 7, 8, array());
$result = iterator_to_array(new RecursiveIteratorIterator(new RecursiveArrayIterator($lst)), false);
var_dump($result);
?>
