printfn "There are %d long primes less than 1000" (primes |> Seq.skip 3 |> Seq.takeWhile(fun n->n<1000) |> Seq.filter isLongPrime |> Seq.length)
