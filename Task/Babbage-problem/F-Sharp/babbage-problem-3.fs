let rec fN g=seq{yield g; yield g+2; yield! fN(g+10)}
printfn "%d" (fN 524|>Seq.find(fun n->n*n%1000000=269696))
