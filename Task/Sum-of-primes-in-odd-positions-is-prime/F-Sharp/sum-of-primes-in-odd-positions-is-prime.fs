// Sum of primes in odd positions is prime. Nigel Galloway: November 9th., 2021
primes32()|>Seq.chunkBySize 2|>Seq.mapi(fun n g->(2*n+1,g.[0]))|>Seq.scan(fun(n,i,g)(e,l)->(e,l,g+l))(0,0,0)|>Seq.takeWhile(fun(_,n,_)->n<1000)|>Seq.filter(fun(_,_,n)->isPrime n)|>Seq.iter(fun(n,g,l)->printfn $"i=%3d{n} p[i]=%3d{g} sum=%5d{l}")
