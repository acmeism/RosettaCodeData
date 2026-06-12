// Summation of primes. Nigel Galloway: November 9th., 2021
printfn $"%d{primes64()|>Seq.takeWhile((>)2000000L)|>Seq.sum}"
