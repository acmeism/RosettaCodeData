Seq.initInfinite id |> Seq.takeWhile(fun n->n=0 || n%6>0) |> Seq.iter (fun n-> printfn "%d" n)
