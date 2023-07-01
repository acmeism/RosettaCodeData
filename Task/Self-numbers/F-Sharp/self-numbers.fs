// Self numbers. Nigel Galloway: October 6th., 2020
let fN g=let rec fG n g=match n/10 with 0->n+g |i->fG i (g+(n%10)) in fG g g
let Self=let rec Self n i g=seq{let g=g@([n..i]|>List.map fN) in yield! List.except g [n..i]; yield! Self (n+100) (i+100) (List.filter(fun n->n>i) g)} in Self 0 99 []

Self |> Seq.take 50 |> Seq.iter(printf "%d "); printfn ""
printfn "\n%d" (Seq.item 99999999 Self)
