<?php
// Function to check if a number is prime
function isPrime($n) {
    if ($n <= 1) {
        return false;
    }
    for ($i = 2; $i <= sqrt($n); $i++) {
        if ($n % $i == 0) {
            return false;
        }
    }
    return true;
}

// Function to sum the digits of a number until the sum is a single digit
function sumOfDigits($n) {
    while ($n > 9) {
        $sum = 0;
        while ($n > 0) {
            $sum += $n % 10;
            $n = (int)($n / 10);
        }
        $n = $sum;
    }
    return $n;
}

function findNicePrimes($lower_limit=501, $upper_limit=1000) {
	// Find all Nice primes within the specified range
    $nice_primes = array();
    for ($n = $lower_limit; $n < $upper_limit; $n++) {
        if (isPrime($n)) {
            $sumn = sumOfDigits($n);
            if (isPrime($sumn)) {
                array_push($nice_primes, $n);
            }
        }
    }
    return $nice_primes;
}
// Main loop to find and print "Nice Primes"
$nice_primes = findNicePrimes();
foreach ($nice_primes as $prime) {
    echo $prime . " ";
}
?>
