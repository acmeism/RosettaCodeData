// Primes (+)2..p is prime. Nigel Galloway: July 7th., 2021
primes32()|>Seq.takeWhile((>)1000)|>Seq.scan(fun(n,_) g->(n+g,g))(0,0)|>Seq.filter(fun(n,_)->isPrime n)|>Seq.iter(fun(_,n)->printf "%d " n); printfn ""
