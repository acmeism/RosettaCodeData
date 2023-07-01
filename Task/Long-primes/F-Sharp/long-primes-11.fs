printfn "There are %d long primes less than 128000" (primes |> Seq.skip 3 |> Seq.takeWhile(fun n->n<128000) |> Seq.filter isLongPrime|> Seq.length)
