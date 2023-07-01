function sum_multiples($max, $divisor) {
    // Number of multiples of $divisor <= $max
    $num = floor($max / $divisor);
    // Sum of multiples of $divisor
    return ($divisor * $num * ($num + 1) / 2);
}

$max = 1000;
$sum = sum_multiples($max - 1,  3)
     + sum_multiples($max - 1,  5)
     - sum_multiples($max - 1, 15);
echo $sum, PHP_EOL;
