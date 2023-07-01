// Own digits power sum. Nigel Galloway: October 2th., 2021
let fN g=let N=[|for n in 0..9->pown n g|] in let rec fN g=function n when n<10->N.[n]+g |n->fN(N.[n%10]+g)(n/10) in (fun g->fN 0 g)
{3..9}|>Seq.iter(fun g->let fN=fN g in printf $"%d{g} digit are:"; {pown 10 (g-1)..(pown 10 g)-1}|>Seq.iter(fun g->if g=fN g then printf $" %d{g}"); printfn "")
