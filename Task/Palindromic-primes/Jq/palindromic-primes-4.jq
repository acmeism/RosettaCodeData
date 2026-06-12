"Palindromic primes < 1000:",
emit_until(. >= 1000;  palindromic_primes),

((range(5;11) | pow(10;.)) as $n
 | "\nNumber of palindromic primes <= \($n): \(count(emit_until(. >= $n; palindromic_primes)))" )
