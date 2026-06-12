<?php
function permutate($values, $size, $offset) {
    $count = count($values);
    $array = array();
    for ($i = 0; $i < $size; $i++) {
        $selector = ($offset / pow($count,$i)) % $count;
        $array[$i] = $values[$selector];
    }
    return $array;
}

function permutations($values, $size) {
    $a = array();
    $c = pow(count($values), $size);
    for ($i = 0; $i<$c; $i++) {
        $a[$i] = permutate($values, $size, $i);
    }
    return $a;
}

$permutations = permutations(['bat','fox','cow'], 2);
foreach ($permutations as $permutation) {
    echo join(',', $permutation)."\n";
}
