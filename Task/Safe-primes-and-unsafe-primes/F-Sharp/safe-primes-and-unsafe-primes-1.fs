pCache |> Seq.filter(fun n->isPrime((n-1)/2)) |> Seq.take 35 |> Seq.iter (printf "%d ")
