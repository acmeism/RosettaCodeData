printfn "There are %d long primes less than 32000" (primes |> Seq.skip 3 |> Seq.takeWhile(fun n->n<32000) |> Seq.filter isLongPrime |> Seq.length)
