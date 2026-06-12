// Nigel Galloway. April 9th., 2021
let rec fN i g e l=match l%i=g,l/10I with (true,_)->e |(_,l) when l=0I->fN i g (e*6I) (e*6I) |(_,l)->fN i g e l
[0I..99I]|>Seq.iter(fun n->printfn "%2d %A" (int n)(fN(if n>9I then 100I else 10I) n 1I 1I))
