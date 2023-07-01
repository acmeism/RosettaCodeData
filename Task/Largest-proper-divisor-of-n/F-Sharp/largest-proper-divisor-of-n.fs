// Largest proper divisor of n: Nigel Galloway. June 2nd., 2021
let fN g=let rec fN n=let i=Seq.head n in match(g/i,g%i) with (1,_)->1 |(n,0)->n |_->fN(Seq.tail n) in fN(Seq.initInfinite((+)2))
seq{yield 1; yield! seq{2..100}|>Seq.map fN}|>Seq.iter(printf "%d "); printfn ""
