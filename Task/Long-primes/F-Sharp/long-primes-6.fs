printfn "There are %d long primes less than 4000" (primes |> Seq.skip 3 |> Seq.takeWhile(fun n->n<4000) |> Seq.filter isLongPrime|> Seq.length)
