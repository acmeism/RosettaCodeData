<?php
// RPN Calculator
//
// Nigel Galloway - April 3rd., 2012
//
$WSb = '(?:^|\s+)';
$WSa = '(?:\s+|$)';
$num = '([+-]?(?:\.\d+|\d+(?:\.\d*)?))';
$op = '([-+*\/^])';

function myE($m) {
    return $m[3] == '^' ? ' ' . pow($m[1], $m[2]) . ' ' : ' ' . eval("return " . $m[1] . $m[3] . $m[2] . ";") . ' ';
}

while (!feof(STDIN)) {
    $s = trim(fgets(STDIN));
    if ($s == '')
        continue;
    do {
        $s = preg_replace_callback("/$WSb$num\\s+$num\\s+$op$WSa/", "myE", $s, -1, $n);
    } while ($n);
    echo floatval($s) . "\n";
}
?>
