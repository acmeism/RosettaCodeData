using Primes

primorials(N) = accumulate(*, primes(N), init = big"1")

primorial = primorials(800)

fortunate(n) = nextprime(primorial[n] + 2) - primorial[n]

println("After sorting, the first 50 distinct fortunate numbers are:")
foreach(p -> print(rpad(last(p), 5), first(p) % 10 == 0 ? "\n" : ""),
    (map(fortunate, 1:100) |> unique |> sort!)[begin:50] |> enumerate)
