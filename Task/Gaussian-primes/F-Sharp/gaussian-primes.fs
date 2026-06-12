// Gaussian primes. Nigel Galloway: July 29th., 2022
let isGP=function (n,0)|(0,n)->let n=abs n in n%4=3 && isPrime n |(n,g)->isPrime(n*n+g*g)
Seq.allPairs [-9..9] [-9..9]|>Seq.filter isGP|>Seq.iter(fun(n,g)->printf $"""%d{n}%s{match g with 0->"" |g->sprintf $"%+d{g}i"} """); printfn ""
