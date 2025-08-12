// Multiplicative order. Nigel Galloway: August 5th., 2025
let lcm(n:bigint seq)=MathNet.Numerics.Euclid.LeastCommonMultiple(n|>Array.ofSeq)
let factors(n:bigint)=Open.Numeric.Primes.Extensions.PrimeExtensions.PrimeFactors &n|>Seq.countBy id|>Seq.skip 1
let rec fN i g e l=match i with i when i=1I->g |i->fN (expMod i e l) (g*e) e l
let localOrder n g l=factors(g)|>Seq.fold(fun r (q,e)->fN (expMod n (g/q**e) l) r q l) 1I
let order n g=factors(g)|>Seq.map(fun(p,k)->localOrder n ((p-1I)*p**(k-1)) (p**k))|>lcm
let tests=[(37I,1000I);(10I**100+1I,7919I);(10I**1000+1I,15485863I);(10I**10000-1I,22801763489I)]
tests|>List.iter(fun(n,g)->printfn "%A" (order n g))
