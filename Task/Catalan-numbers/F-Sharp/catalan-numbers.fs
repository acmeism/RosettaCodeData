Seq.unfold(fun (c,n) -> let cc = 2*(2*n-1)*c/(n+1) in Some(c,(cc,n+1))) (1,1) |> Seq.take 15 |> Seq.iter (printf "%i, ")
