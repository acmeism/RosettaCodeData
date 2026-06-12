// Nice primes. Nigel Galloway: March 22nd., 2021
let fN g=1+((g-1)%9) in primes32()|>Seq.skipWhile((>)500)|>Seq.takeWhile((>)1000)|>Seq.filter(fN>>isPrime)|>Seq.iter(printf "%d "); printfn ""
