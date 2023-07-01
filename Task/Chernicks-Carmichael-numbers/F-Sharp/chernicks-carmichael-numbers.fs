// Generate Chernick's Carmichael numbers. Nigel Galloway: June 1st., 2019
let fMk m k=isPrime(6*m+1) && isPrime(12*m+1) && [1..k-2]|>List.forall(fun n->isPrime(9*(pown 2 n)*m+1))
let fX k=Seq.initInfinite(fun n->(n+1)*(pown 2 (k-4))) |> Seq.filter(fun n->fMk n k )
let cherCar k=let m=Seq.head(fX k) in printfn "m=%d primes -> %A " m ([6*m+1;12*m+1]@List.init(k-2)(fun n->9*(pown 2 (n+1))*m+1))
[4..9] |> Seq.iter cherCar
