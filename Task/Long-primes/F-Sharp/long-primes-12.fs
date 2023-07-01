printfn "There are %d long primes less than 256000" (primes |> Seq.skip 3 |> Seq.takeWhile(fun n->n<256000) |> Seq.filter isLongPrime|> Seq.length)
