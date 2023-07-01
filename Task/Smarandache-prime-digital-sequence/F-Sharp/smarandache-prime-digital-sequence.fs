// Generate Smarandache prime-digital sequence. Nigel Galloway: May 31st., 2019
let rec spds g=seq{yield! g; yield! (spds (Seq.collect(fun g->[g*10+2;g*10+3;g*10+5;g*10+7]) g))}|>Seq.filter(isPrime)
spds [2;3;5;7] |> Seq.take 25 |> Seq.iter(printfn "%d")
printfn "\n\n100th item of this sequence is %d" (spds [2;3;5;7] |> Seq.item 99)
printfn "1000th item of this sequence is %d" (spds [2;3;5;7] |> Seq.item 999)
