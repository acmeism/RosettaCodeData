//  Factorians. Nigel Galloway: October 22nd., 2021
let N=[|let mutable n=1 in yield n; for g in 1..11 do n<-n*g; yield n|]
let fG n g=let rec fN g=function i when i<n->g+N.[i] |i->fN(g+N.[i%n])(i/n) in fN 0 g
{9..12}|>Seq.iter(fun n->printf $"In base %d{n} Factorians are:"; {1..1500000}|>Seq.iter(fun g->if g=fG n g then printf $" %d{g}"); printfn "")
