let uPx x=let rec fN n g=seq{yield! {n+x..10..g-1}|>Seq.map(fun g->(max 1 n,g)); yield! fN(g)(g*10)} in fN 0 10|>Seq.filter(fG>>not)|>Seq.map snd
[0..9]|>Seq.iter(fun n->printfn "first umprimable number ending in %d is %d" n (uPx n|>Seq.head))
