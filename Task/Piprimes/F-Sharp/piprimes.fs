// PiPrimes: Nigel Galloway. April 5th., 2021
let fN=let i=primes32() in Seq.unfold(fun(n,g,l)->Some(l,if n=g then (n+1,Seq.head i,l+1) else (n+1,g,l)))(1,Seq.head i,0)
fN|>Seq.takeWhile((>)22)|>Seq.chunkBySize 20|>Seq.iter(fun n->Array.iter(printf "%2d ") n; printfn "")
