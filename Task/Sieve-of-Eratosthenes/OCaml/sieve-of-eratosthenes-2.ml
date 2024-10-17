let primes n =
  let primes, _ =
    let sieve = sieve n in
    Array.fold_right
      (fun is_prime (xs, i) -> if is_prime then (i::xs, i-1) else (xs, i-1))
      sieve
      ([], Array.length sieve - 1)
  in
  primes
