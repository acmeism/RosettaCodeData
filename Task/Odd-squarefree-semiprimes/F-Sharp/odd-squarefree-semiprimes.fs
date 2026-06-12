// Odd squarefree semiprimes. Nigel Galloway: January 4th., 2023
let n=primes32()|>Seq.skip 1|>Seq.takeWhile((>)333)|>List.ofSeq
List.allPairs n n|>Seq.filter(fun(n,g)->n<g)|>Seq.map(fun(n,g)->n*g)|>Seq.filter((>)1000)|>Seq.iter(printf "%d "); printfn ""
