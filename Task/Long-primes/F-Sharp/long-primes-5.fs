printfn "There are %d long primes less than 2000" (primes |> Seq.skip 3 |> Seq.takeWhile(fun n->n<2000) |> Seq.filter isLongPrime |> Seq.length)
