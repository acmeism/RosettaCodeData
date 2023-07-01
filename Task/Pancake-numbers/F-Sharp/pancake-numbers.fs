// Pancake numbers. Nigel Galloway: October 28th., 2020
let pKake z=let n=[for n in 1..z-1->Array.ofList([n.. -1..0]@[n+1..z-1])]
            let e=let rec fG n g=match g with 0->n |_->fG (n*g) (g-1) in fG 1 z
            let rec fN i g l=match (Set.count g)-e with 0->(i,List.last l)
                                                       |_->let l=l|>List.collect(fun g->[for n in n->List.permute(fun g->n.[g]) g])|>Set.ofList
                                                           fN (i+1) (Set.union g l) (Set.difference l g|>Set.toList)
            fN 0 (set[[1..z]]) [[1..z]]

[1..9]|>List.iter(fun n->let i,g=pKake n in printfn "Maximum number of flips to sort %d elements is %d. e.g %A->%A" n i g [1..n])
