// Base 16 representation: Nigel Galloway. June 3rd., 2021
let rec fN g=match g%16,g/16 with (n,0)->9<n |(n,g) when n<10->fN g |_->true
seq{1..500}|>Seq.filter fN|>Seq.iter(printf "%d "); printfn ""
