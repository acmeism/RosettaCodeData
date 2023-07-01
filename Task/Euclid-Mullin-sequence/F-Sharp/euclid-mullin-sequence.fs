//Euclid-Mullin sequence. Nigel Galloway: October 29th., 2021
let(|Prime|_|)(n,g)=if Open.Numeric.Primes.MillerRabin.IsProbablePrime &g then Some(n*g,n*g+1I) else None
let n=Seq.unfold(fun(n,g)->match n,g with Prime n->Some(g,n) |_->let g=Open.Numeric.Primes.Extensions.PrimeExtensions.PrimeFactors g|>Seq.item 1 in Some(g,(n*g,n*g+1I)))(1I,2I)
n|>Seq.take 16|>Seq.iter(printfn "%A")
