<?php
function flatten($ary) {
    $result = array();
    array_walk_recursive($ary, function($x, $k) use (&$result) { $result[] = $x; });
    return $result;
}

$lst = array(array(1), 2, array(array(3, 4), 5), array(array(array())), array(array(array(6))), 7, 8, array());
var_dump(flatten($lst));
?>
