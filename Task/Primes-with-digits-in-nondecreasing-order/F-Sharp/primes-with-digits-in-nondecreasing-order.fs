// Primes with digits in nondecreasing order: Nigel Galloway. May 16th., 2021
let rec fN g=function n when n<10->(n<=g) |n when (n%10)<=g->fN(n%10)(n/10) |_->false
let fN=fN 9 in primes32()|>Seq.takeWhile((>)1000)|>Seq.filter fN|>Seq.iter(printf "%d "); printfn ""
