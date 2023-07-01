def count(s): reduce s as $_ (0; .+1);

# Emit {strong, weak} primes up to and including $n
def strong_weak_primes:
   . as $n
   | primes as $primes
   | ("\nCheck: last prime generated: \($primes[-1])" | debug) as $debug
   | reduce range(1; $primes|length-1) as $p ({};
       (($primes[$p-1] + $primes[$p+1]) / 2) as $x
       | if $primes[$p] > $x
         then .strong += [$primes[$p]]
         elif $primes[$p] < $x
         then .weak += [$primes[$p]]
	 else .
	 end );

(1e7 + 19)
  | strong_weak_primes as {$strong, $weak}
  | "The first 36 strong primes are:",
    $strong[:36],
  "\nThe count of the strong primes below 1e6: \(count($strong[]|select(. < 1e6 )))",
  "\nThe count of the strong primes below 1e7: \(count($strong[]|select(. < 1e7 )))",

  "\nThe first 37 weak primes are:",
  $weak[:37],
  "\nThe count of the weak primes below 1e6: \(count($weak[]|select(. < 1e6 )))",
  "\nThe count of the weak primes below 1e7: \(count($weak[]|select(. < 1e7 )))"
