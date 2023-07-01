let n=palindromicCyclops|>Seq.findIndex(fun n->n>10000000) in printfn "First palindromic prime Cyclop number > 10,000,000 is %d at index %d" (Seq.item n (palindromicCyclops)) n
