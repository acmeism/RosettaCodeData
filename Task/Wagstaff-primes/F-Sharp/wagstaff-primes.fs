// Wagstaff primes. Nigel Galloway: September 15th., 2022
let isWagstaff n=let mutable g=(1I+2I**n)/3I in if Open.Numeric.Primes.MillerRabin.IsProbablePrime &g then Some (n,g) else None
primes32()|>Seq.choose isWagstaff|>Seq.take 10|>Seq.iter(fun (n,g)->printfn $"%d{n}->%A{g}")
primes32()|>Seq.choose isWagstaff|>Seq.skip 10|>Seq,take 14|>Seq.iter(fun(n,_)->printf $"%d{n} "); printfn ""
