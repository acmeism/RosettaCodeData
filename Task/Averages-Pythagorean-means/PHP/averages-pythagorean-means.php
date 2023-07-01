<?php
// Created with PHP 7.0

function ArithmeticMean(array $values)
{
    return array_sum($values) / count($values);
}

function GeometricMean(array $values)
{
    return array_product($values) ** (1 / count($values));
}

function HarmonicMean(array $values)
{
    $sum = 0;

    foreach ($values as $value) {
        $sum += 1 / $value;
    }

    return count($values) / $sum;
}

$values = array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

echo "Arithmetic: " . ArithmeticMean($values) . "\n";
echo "Geometric: " . GeometricMean($values) . "\n";
echo "Harmonic: " . HarmonicMean($values) . "\n";
