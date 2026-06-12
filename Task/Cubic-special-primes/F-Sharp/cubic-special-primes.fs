// Cubic Special Primes: Nigel Galloway. March 30th., 2021
let fN=let N=[for n in [0..25]->n*n*n] in let mutable n=2 in (fun g->match List.contains(g-n)N with true->n<-g; true |_->false)
primes32()|>Seq.takeWhile((>)16000)|>Seq.filter fN|>Seq.iter(printf "%d "); printfn ""
