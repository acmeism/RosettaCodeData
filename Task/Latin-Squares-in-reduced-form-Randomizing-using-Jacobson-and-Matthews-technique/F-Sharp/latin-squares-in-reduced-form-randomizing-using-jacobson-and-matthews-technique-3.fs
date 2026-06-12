randLS 5 |> Seq.take 10000 |> Seq.map asNormLS |> Seq.countBy id |> Seq.iteri(fun n g->printf "%d(%d) " (n+1) (snd g)); printfn ""
