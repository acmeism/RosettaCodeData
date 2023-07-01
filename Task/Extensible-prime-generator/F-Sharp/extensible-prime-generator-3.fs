primes32() |> Seq.skipWhile (fun n->n<100) |> Seq.takeWhile (fun n->n<=150) |> Seq.iter (fun n -> printf "%d " n)
