// Ramanujan primes. Nigel Galloway: September 7th., 2021
let fN g=if isPrime g then 1 else if g%2=1 then 0 else if isPrime(g/2) then -1 else 0
let rP p=let N,G=Array.create p 0,(Seq.item(3*p-2)(primes32()))+1 in let rec fG n g=if g=G then N else(if n<p then N.[n]<-g); fG(n+(fN g))(g+1) in fG 0 1
let n=rP 100000
n.[0..99]|>Array.iter(printf "%d "); printfn ""
[1000;10000;100000]|>List.iter(fun g->printf $"The %d{g}th Ramanujan prime is %d{n.[g-1]}\n" )
