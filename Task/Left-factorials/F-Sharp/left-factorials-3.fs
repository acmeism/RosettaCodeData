LF |> Seq.skip 20 |> Seq.take 91 |> Seq.iteri(fun n g->if n%10=0 then printfn "%A" g)
