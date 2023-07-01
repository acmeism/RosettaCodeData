// Weiferich primes: Nigel Galloway. June 2nd., 2021
primes32()|>Seq.takeWhile((>)5000)|>Seq.filter(fun n->(2I**(n-1)-1I)%(bigint(n*n))=0I)|>Seq.iter(printfn "%d")
