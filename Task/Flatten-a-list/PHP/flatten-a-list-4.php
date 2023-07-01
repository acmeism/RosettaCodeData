<?php
function flatten_helper($x, $k, $obj) {
    $obj->flattened[] = $x;
}

function flatten($ary) {
    $obj = (object)array('flattened' => array());
    array_walk_recursive($ary, 'flatten_helper', $obj);
    return $obj->flattened;
}

$lst = array(array(1), 2, array(array(3, 4), 5), array(array(array())), array(array(array(6))), 7, 8, array());
var_dump(flatten($lst));
?>
