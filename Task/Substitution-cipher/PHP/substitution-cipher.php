<?php

$alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
$key      = 'cPYJpjsBlaOEwRbVZIhQnHDWxMXiCtUToLkFrzdAGymKvgNufeSq';

// Encode input.txt, and save result in output.txt
file_put_contents('output.txt', strtr(file_get_contents('input.txt'), $alphabet, $key));

$source  = file_get_contents('input.txt');
$encoded = file_get_contents('output.txt');
$decoded = strtr($encoded, $key, $alphabet);

echo
    '== SOURCE ==', PHP_EOL,
    $source, PHP_EOL, PHP_EOL,
    '== ENCODED ==', PHP_EOL,
    $encoded, PHP_EOL, PHP_EOL,
    '== DECODED ==', PHP_EOL,
    $decoded, PHP_EOL, PHP_EOL;
