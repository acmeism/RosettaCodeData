// Prime Fibonacci Numbers. Nigel Galloway: January 21st., 2022
seq{yield! [2I;3I]; yield! MathNet.Numerics.Generate.FibonacciSequence()|>Seq.skip 5|>Seq.filter(fun n->n%4I=1I && Open.Numeric.Primes.MillerRabin.IsProbablePrime &n)}|>Seq.take 23|>Seq.iteri(fun n g->printfn "%2d->%A" (n+1) g)
