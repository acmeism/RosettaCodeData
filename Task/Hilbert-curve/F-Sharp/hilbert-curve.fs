// Hilbert curve. Nigel Galloway: September 18th., 2023
type C= |At|Cl|Ab|Cr
type D= |Z|U|D|L|R
let fD=function Z->0,0 |U->0,1 |D->0,-1 |L-> -1,0 |R->1,0
let fC=function At->[fD D;fD R;fD U] |Cl->[fD R;fD D;fD L] |Ab->[fD U;fD L;fD D] |Cr->[fD L;fD U;fD R]
let order(n,g)=match g with At->[n,Cl;D,At;R,At;U,Cr]
                           |Cl->[n,At;R,Cl;D,Cl;L,Ab]
                           |Ab->[n,Cr;U,Ab;L,Ab;D,Cl]
                           |Cr->[n,Ab;L,Cr;U,Cr;R,At]
let hilbert=Seq.unfold(fun n->Some(n,n|>List.collect order))[Z,At]
hilbert|>Seq.take 7|>Seq.iteri(fun n g->Chart.Line(g|>Seq.collect(fun(n,g)->(fD n)::(fC g))|>Seq.scan(fun(x,y)(n,g)->(x+n,y+g))(0,0))|>Chart.withTitle(sprintf "Hilbert order %d" n)|>Chart.show)
