<?php
function flatten($ary) {
    $result = array();
    foreach ($ary as $x) {
        if (is_array($x))
            // append flatten($x) onto $result
            array_splice($result, count($result), 0, flatten($x));
        else
            $result[] = $x;
    }
    return $result;
}

$lst = array(array(1), 2, array(array(3, 4), 5), array(array(array())), array(array(array(6))), 7, 8, array());
var_dump(flatten($lst));
?>
