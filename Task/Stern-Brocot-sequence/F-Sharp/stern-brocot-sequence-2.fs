sb |> Seq.take 15 |> Seq.iter(printf "%d ");printfn ""
[1..10] |> List.map(fun n->(n,(sb|>Seq.findIndex(fun g->g=n))+1)) |> List.iter(printf "%A ");printfn ""
printfn "%d" ((sb|>Seq.findIndex(fun g->g=100))+1)
printfn "There are %d consecutive members, of the first thousand members, with GCD <> 1" (sb |> Seq.take 1000 |>Seq.pairwise |> Seq.filter(fun(n,g)->gcd n g <> 1) |> Seq.length)
