printfn "%d" (primes32() |> Seq.skipWhile (fun n->n<7700) |> Seq.takeWhile (fun n->n<=8000) |> Seq.length)
