// Next special primes. Nigel Galloway: March 26th., 2021
let mP=let mutable n,g=2,0 in primes32()|>Seq.choose(fun y->match y-n>g,n with (true,i)->g<-y-n; n<-y; Some(i,g,y) |_->None)
mP|>Seq.takeWhile(fun(_,_,n)->n<1050)|>Seq.iteri(fun i (n,g,l)->printfn "n%d=%d n%d=%d n%d-n%d=%d" i n (i+1) l (i+1) i g)
