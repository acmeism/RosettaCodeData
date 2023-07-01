printfn "There are %d unsafe primes less than 10000000" (pCache |> Seq.takeWhile(fun n->n<10000000) |> Seq.filter(fun n->not (isPrime((n-1)/2))) |> Seq.length);;
