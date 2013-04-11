<?php
function flat(&$ary) { // argument must be by reference or array will just be copied
    for ($i = 0; $i < count($ary); $i++) {
        while (is_array($ary[$i])) {
            array_splice($ary, $i, 1, $ary[$i]);
        }
    }
}

$lst = array(array(1), 2, array(array(3, 4), 5), array(array(array())), array(array(array(6))), 7, 8, array());
flat($lst);
var_dump($lst);
?>
