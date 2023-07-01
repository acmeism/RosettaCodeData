def hundred:
  Sundaram_primes(100)
  | nwise(10)
  | map(lpad(3))
  | join(" ");

"First hundred:", hundred,
"\nMillionth is \(Sundaram_primes(1000000)[-1])"
