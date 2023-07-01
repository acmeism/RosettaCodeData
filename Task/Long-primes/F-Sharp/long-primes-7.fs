printfn "There are %d long primes less than 8000" (primes |> Seq.skip 3 |> Seq.takeWhile(fun n->n<8000) |> Seq.filter isLongPrime |> Seq.length)
