// Cullen and Woodall numbers. Nigel Galloway: January 14th., 2022
let Cullen,Woodall=let fG n (g:int)=(bigint g)*2I**g+n in fG 1I, fG -1I
Seq.initInfinite((+)1>>Cullen)|>Seq.take 20|>Seq.iter(printf "%A "); printfn ""
Seq.initInfinite((+)1>>Woodall)|>Seq.take 20|>Seq.iter(printf "%A "); printfn ""
Seq.initInfinite((+)1)|>Seq.filter(fun n->let mutable  n=Woodall n in Open.Numeric.Primes.MillerRabin.IsProbablePrime &n)|>Seq.take 12|>Seq.iter(printf "%A "); printfn ""
Seq.initInfinite((+)1)|>Seq.filter(fun n->let mutable  n=Cullen n in Open.Numeric.Primes.MillerRabin.IsProbablePrime &n)|>Seq.take 5|>Seq.iter(printf "%A "); printfn ""
