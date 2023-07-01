printfn "There are %d long primes less than 500" (primes |> Seq.skip 3 |> Seq.takeWhile(fun n->n<500) |> Seq.filter isLongPrime |> Seq.length)
