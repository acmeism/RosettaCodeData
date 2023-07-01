// Primorial Numbers. Nigel Galloway: August 3rd., 2021
primes32()|>Seq.scan((*)) 1|>Seq.take 10|>Seq.iter(printf "%d "); printfn "\n"
[10;100;1000;10000;100000]|>List.iter(fun n->printfn "%d" ((int)(System.Numerics.BigInteger.Log10 (Seq.item n (primesI()|>Seq.scan((*)) 1I)))+1))
