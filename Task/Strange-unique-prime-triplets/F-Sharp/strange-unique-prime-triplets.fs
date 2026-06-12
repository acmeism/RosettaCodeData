// Strange unique prime triplets. Nigel Galloway: March 12th., 2021
let sP n=let N=primes32()|>Seq.takeWhile((>)n)|>Array.ofSeq
         seq{for n in 0..N.Length-1 do for i in n+1..N.Length-1 do for g in i+1..N.Length-1->(N.[n],N.[i],N.[g])}|>Seq.filter(fun(n,i,g)->isPrime(n+i+g))
sP 30|>Seq.iteri(fun n(i,g,l)->printfn "%2d: %2d+%2d+%2d=%2d")
printfn "%d" (Seq.length(sP 1000))
printfn "%d" (Seq.length(sP 10000))
