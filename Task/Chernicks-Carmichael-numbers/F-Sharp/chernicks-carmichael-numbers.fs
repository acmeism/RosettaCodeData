// Generate Chernick's Carmichael numbers. Nigel Galloway: June 1st., 2019
open Open.Numeric.Primes
let fMk m k=Number.IsPrime(6UL*m+1UL) && Number.IsPrime(12UL*m+1UL) && [1..k-2]|>List.forall(fun n->Number.IsPrime(9UL*(pown 2UL n)*m+1UL))
let fX k=Seq.initInfinite(fun n->match k with 3->uint64(n+1) |_->uint64(n+1)*(pown 2UL (k-4)))|>Seq.filter(fun n->fMk n k)
let cherCar k=let m=Seq.head(fX k) in sprintf "m=%d primes-> %A " m ([6UL*m+1UL;12UL*m+1UL]@List.init(k-2)(fun n->9UL*(pown 2UL (n+1))*m+1UL))
[3..9] |> Seq.iter(fun g->printfn $"cherCar %d{g}: %s{cherCar g}")
