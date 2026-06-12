// Cousin Primes: Nigel Galloway. April 2nd., 2021
primes32()|>Seq.pairwise|>Seq.takeWhile(fun(_,n)->n<1000)|>Seq.filter(fun(n,g)->g-n=4)|>Seq.iter(fun(n,g)->printf "(%d,%d) "n g); printfn ""
