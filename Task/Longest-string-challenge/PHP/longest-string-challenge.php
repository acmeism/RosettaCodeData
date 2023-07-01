<?php

echo 'Enter strings (empty string to finish) :', PHP_EOL;

$output = $previous = readline();
while ($current = readline()) {
    $p = $previous;
    $c = $current;
    // Remove first character from strings until one of them is empty
    while ($p and $c) {
        $p = substr($p, 1);
        $c = substr($c, 1);
    }
    // If $p and $c are empty : strings are of equal length
    if (!$p and !$c) {
        $output .= PHP_EOL . $current;
    }
    // If $c is not empty, $current is longer
    if ($c) {
        $output = $previous = $current;
    }
}

echo 'Longest string(s) = ', PHP_EOL, $output, PHP_EOL;
