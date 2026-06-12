// Fermat pseudoprimes. Nigel Galloway: August 17th., 2022
let fp(a:int)=let a=bigint a in primesI()|>Seq.pairwise|>Seq.collect(fun(n,g)->seq{for n in n+1I..g-1I do if bigint.ModPow(a,n-1I,n)=1I then yield n})
{1..20}|>Seq.iter(fun n->printf $"Base %2d{n} - Up to 50000: %5d{fp n|>Seq.takeWhile((>=)50000I)|>Seq.length} First 20: ("; fp n|>Seq.take 20|>Seq.iter(printf "%A "); printfn ")")
