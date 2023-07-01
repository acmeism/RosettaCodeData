printfn "There are %d long primes less than 16000" (primes |> Seq.skip 3 |> Seq.takeWhile(fun n->n<16000) |> Seq.filter isLongPrime |> Seq.length)
