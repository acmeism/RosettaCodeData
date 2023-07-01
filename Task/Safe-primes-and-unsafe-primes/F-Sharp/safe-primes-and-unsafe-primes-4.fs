pCache |> Seq.filter(fun n->not (isPrime((n-1)/2))) |> Seq.take 40 |> Seq.iter (printf "%d ")
