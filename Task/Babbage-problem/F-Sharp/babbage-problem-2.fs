Seq.initInfinite id
|> Seq.skipWhile (fun n->(n*n % 1000000) <> 269696)
|> Seq.head |> printfn "%d"
