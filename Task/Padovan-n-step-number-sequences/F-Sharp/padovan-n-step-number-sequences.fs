// Padovan n-step number sequences. Nigel Galloway: July 28th., 2021
let rec pad=function 2->Seq.unfold(fun(n:int[])->Some(n.[0],Array.append n.[1..2] [|Array.sum n.[0..1]|]))[|1;1;1|]
                    |g->Seq.unfold(fun(n:int[])->Some(n.[0],Array.append n.[1..g] [|Array.sum n.[0..g-1]|]))(Array.ofSeq(pad(g-1)|>Seq.take(g+1)))
[2..8]|>List.iter(fun n->pad n|>Seq.take 15|>Seq.iter(printf "%d "); printfn "")
