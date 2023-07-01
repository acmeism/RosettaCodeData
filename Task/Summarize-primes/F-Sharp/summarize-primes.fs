// Summarize Primes: Nigel Galloway. April 16th., 2021
primes32()|>Seq.takeWhile((>)1000)|>Seq.scan(fun(n,g) p->(n+1,g+p))(0,0)|>Seq.filter(snd>>isPrime)|>Seq.iter(fun(n,g)->printfn "%3d->%d" n g)
