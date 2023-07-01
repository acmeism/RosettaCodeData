<?php

function isPrime($n)
{
    if ($n == 2)
        return true;
    if ($n == 1 || $n % 2 == 0)
        return false;
    $root = intval(sqrt($n));
    for ($k = 3; $k <= $root; $k += 2)
        if ($n % $k == 0)
            return false;
    return true;
}

$queue = [];
$primes = [];

$begin = 0;
$end = 0;

for ($k = 1; $k <= 9; $k++)
    $queue[$end++] = $k;

while ($begin < $end)
{
    $n = $queue[$begin++];

    if (isPrime($n))
        $primes[] = $n;
    for ($k = $n % 10 + 1; $k <= 9; $k++)
        $queue[$end++] = $n * 10 + $k;
}

foreach($primes as $p)
    echo "$p ";
