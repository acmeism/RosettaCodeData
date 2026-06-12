// Decimal-Hexdecimal: Nigel Galloway. June 7th., 2021
let rec fN g=function n when n<10->Some(Set.add n g)|n when n%16<10->fN(g.Add(n%16))(n/16) |_->None
let rec fG n g=match n/10,n%10 with (0,n)->Some(Set.add n g)|(n,i)->fG n (Set.add i g)
let g=Set.empty in seq{0..100000}|>Seq.filter(fun n->fN g n=fG n g)|>Seq.iter(printf "%d "); printfn ""
