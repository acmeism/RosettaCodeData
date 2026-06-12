// Nigel Galloway. April 5th., 2021
let fN g=let rec fN g=function n when n<2->(char(n+48))::g |n->fN((char(n%2+48))::g)(n/2) in fN [] g|>Array.ofList|>System.String
Seq.unfold(fun(n,g,l)->Some((n<<<l)+n,if n=g-1 then (n+1,g*2,l+1) else (n+1,g,l)))(1,2,1)|>Seq.takeWhile((>)1000)|>Seq.iter(fun g->printfn "%3d %s" g (fN g))
