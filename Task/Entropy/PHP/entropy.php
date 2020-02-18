<?php

function shannonEntropy($string) {
    $h = 0.0;
    $len = strlen($string);
    foreach (count_chars($string, 1) as $count) {
        $h -= (double) ($count / $len) * log((double) ($count / $len), 2);
    }
    return $h;
}

$strings = array(
    '1223334444',
    '1225554444',
    'aaBBcccDDDD',
    '122333444455555',
    'Rosetta Code',
    '1234567890abcdefghijklmnopqrstuvwxyz',
);

foreach ($strings AS $string) {
    printf(
        '%36s : %s' . PHP_EOL,
        $string,
        number_format(shannonEntropy($string), 6)
    );
}
