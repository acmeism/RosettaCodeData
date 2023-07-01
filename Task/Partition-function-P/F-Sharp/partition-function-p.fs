// PartionP: Nigel Galloway. April 12th., 2021
let pP g=let rec fN i g e l=seq{yield(l,e+i);yield(-l,e+i+g);yield! fN(i+1)(g+2)(e+i+g)(-l)}
         let N,G=Array.create(g+1) 1I,seq{yield (1I,1);yield! fN 1 3 1 1I}|>Seq.takeWhile(fun(_,n)->n<=g)|>List.ofSeq
         seq{2..g}|>Seq.iter(fun p->N.[p]<-G|>List.takeWhile(fun(_,n)->n<=p)|>Seq.fold(fun Σ (n,g)->Σ+n*N.[p-g]) 0I); N.[g]
printfn "666->%A\n\n6666->%A\n\n123456->%A" (pP 666) (pP 6666) (pP 123456)
