<?php
// Created with PHP 7.0

function rms(array $numbers)
{
    $sum = 0;

    foreach ($numbers as $number) {
        $sum += $number**2;
    }

    return sqrt($sum / count($numbers));
}

echo rms(array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));
