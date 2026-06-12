// Nigel Galloway. April 9th., 2021
let rec fN i g e l=match g%10,g/10 with (0,_)->false |(n,_) when i%n>0->false |(n,0)->i%(l*n)>0 |(n,g)->fN i g (e+n) (l*n)
seq{1..999}|>Seq.filter(fun n->fN n n 0 1)|>Seq.iter(printf "%d "); printfn ""
