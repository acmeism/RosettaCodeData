// Honaker primes. Nigel Galloway: September 21st., 2022
let rec fG n g=if n<10 then n+g else fG(n/10)(g+n%10)
let Honaker()=primes32()|>Seq.mapi(fun n g->(n+1,g,fG g 0,fG (n+1) 0))|>Seq.choose(fun(i,g,e,l)->if e=l then Some(i,g) else None)
Honaker()|>Seq.chunkBySize 10|>Seq.take 5|>Seq.iter(fun g->g|>Seq.iter(printf "%A "); printfn "")
printfn "%A" (Seq.item 9999 (Honaker()))
