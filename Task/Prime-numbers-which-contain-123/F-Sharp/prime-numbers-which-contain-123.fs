// Numbers containing 123. Nigel Galloway: July 14th., 2021
let rec fN g=if g%1000=123 then true else if g<1230 then false else fN(g/10)
primes32()|>Seq.takeWhile((>)100000)|>Seq.filter fN|>Seq.iter(printf "%d "); printfn ""
printfn "Count to 1 million is %d" (primes32()|>Seq.takeWhile((>)1000000)|>Seq.filter fN|>Seq.length)
