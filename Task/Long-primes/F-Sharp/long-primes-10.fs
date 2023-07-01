printfn "There are %d long primes less than 64000" (primes |> Seq.skip 3 |> Seq.takeWhile(fun n->n<64000) |> Seq.filter isLongPrime|> Seq.length)
