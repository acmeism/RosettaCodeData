primes |> Seq.skip 3 |> Seq.takeWhile(fun n->n<500) |> Seq.filter isLongPrime |> Seq.iter(printf "%d ")
