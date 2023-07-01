LF |> Seq.skip 1000 |> Seq.take 9001 |> Seq.iteri(fun n g->if n%1000=0 then printfn "%d" (string g).Length)
