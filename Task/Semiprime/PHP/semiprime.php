<?php
// Semiprime

function primeFactorsCount($n)
{
    $n = abs($n);
    $count = 0; // Result
    if ($n >= 2)
        for ($factor = 2; $factor <= $n; $factor++)
            while ($n % $factor == 0) {
                $count++;
                $n /= $factor;
            }
    return $count;
}

echo "Enter an integer: ",
$n = (int)fgets(STDIN);
echo (primeFactorsCount($n) == 2 ?
      "It is a semiprime.\n" : "It is not a semiprime.\n");
?>
