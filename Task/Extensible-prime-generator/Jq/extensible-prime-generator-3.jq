"First 20 primes:", (20 | primes), "",

"Primes between 100 and 150:",
   (primes_upto(150) | map(select( 100 < .))), "",

"The 10,000th prime is \( 10000 | primes | .[length - 1] )", "",

(( primes_upto(8000) | count( . > 7700) | length) as $length
    | "There are \($length) primes twixt 7700 and 8000.")
