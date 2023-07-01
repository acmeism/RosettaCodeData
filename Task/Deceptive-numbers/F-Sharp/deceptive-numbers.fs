// Deceptive numbers. Nigel Galloway: February 13th., 2022
Seq.unfold(fun n->Some(n|>Seq.filter(isPrime>>not)|>Seq.filter(fun n->(10I**(n-1)-1I)%(bigint n)=0I),n|>Seq.map((+)30)))(seq{1;7;11;13;17;19;23;29})|>Seq.concat|>Seq.skip 1
|>Seq.chunkBySize 10|>Seq.take 7|>Seq.iter(fun n->n|>Array.iter(printf "%7d "); printfn "")
