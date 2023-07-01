// McNuggets. Nigel Galloway: October 28th., 2018
let fN n g = Seq.initInfinite(fun ng->ng*n+g)|>Seq.takeWhile(fun n->n<=100)
printfn "%d" (Set.maxElement(Set.difference (set[1..100]) (fN 20 0|>Seq.collect(fun n->fN 9 n)|>Seq.collect(fun n->fN 6 n)|>Set.ofSeq)))
