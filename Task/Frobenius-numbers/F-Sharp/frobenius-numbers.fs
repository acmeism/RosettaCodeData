// Frobenius numbers. Nigel Galloway: Octber 18th., 2024
Open.Numeric.Primes.Prime.Numbers|>Seq.pairwise|>Seq.map(fun(n,g)->n*g-n-g)|>Seq.takeWhile((>)10000UL)|>Seq.iter(printfn "%d");;
