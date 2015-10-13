#!/usr/bin/php
<?php

# brackets generator
function bgenerate ($n) {
    if ($n==0) return '';
    $s = str_repeat('[', $n) . str_repeat(']', $n);
    return str_shuffle($s);
}

function printbool($b) {return ($b) ? 'OK' : 'NOT OK';}

function isbalanced($s) {
    $bal = 0;
    for ($i=0; $i < strlen($s); $i++) {
        $ch = substr($s, $i, 1);
        if ($ch == '[') {
            $bal++;
        } else {
            $bal--;
        }
        if ($bal < 0) return false;
    }
    return ($bal == 0);
}

# test parameters are N (see spec)
$tests = array(0, 2,2,2, 3,3,3, 4,4,4,4);

foreach ($tests as $v) {
    $s = bgenerate($v);
    printf("%s\t%s%s", $s, printbool(isbalanced($s)), PHP_EOL);
}
