printfn "There are %d long primes less than 512000" (primes |> Seq.skip 3 |> Seq.takeWhile(fun n->n<512000) |> Seq.filter isLongPrime|> Seq.length)
