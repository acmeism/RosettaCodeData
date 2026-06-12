// Find squares n where n+1 is prime. Nigel Galloway: December 17th., 2021
seq{yield 1; for g in 2..2..30 do let n=g*g in if isPrime(n+1) then yield n}|>Seq.iter(printf "%d "); printfn ""
