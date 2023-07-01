printfn "There are %d safe primes less than 1000000" (pCache |> Seq.takeWhile(fun n->n<1000000) |> Seq.filter(fun n->isPrime((n-1)/2)) |> Seq.length)
