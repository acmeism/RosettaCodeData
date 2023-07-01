// Repunit primes. Nigel Galloway: January 24th., 2022
let rUnitP(b:int)=let b=bigint b in primes32()|>Seq.takeWhile((>)1000)|>Seq.map(fun n->(n,((b**n)-1I)/(b-1I)))|>Seq.filter(fun(_,n)->Open.Numeric.Primes.MillerRabin.IsProbablePrime &n)|>Seq.map fst
[2..16]|>List.iter(fun n->printf $"Base %d{n}: "; rUnitP(n)|>Seq.iter(printf "%d "); printfn "")
