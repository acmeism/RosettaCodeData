let isPrimeI x =
    if x < 2I then false else
    if x = 2I then true else
    if x % 2I = 0I then false else
    let rec test n =
      if n * n > x then true else
      if x % n = 0I then false else test (n + 2I) in test 3I
