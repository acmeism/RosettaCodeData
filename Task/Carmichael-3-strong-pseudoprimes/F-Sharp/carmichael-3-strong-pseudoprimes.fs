// Carmichael Number . Nigel Galloway: November 19th., 2017
let fN n = Seq.collect ((fun g->(Seq.map(fun e->(n,1+(n-1)*(n+g)/e,g,e))){1..(n+g-1)})){2..(n-1)}
let fG (P1,P2,h3,d) =
  let mod' n g = (n%g+g)%g
  let fN P3 = if isPrime P3 && (P2*P3)%(P1-1)=1 then Some (P1,P2,P3) else None
  if isPrime P2 && ((h3+P1)*(P1-1))%d=0 && mod' (-P1*P1) h3=d%h3 then fN (1+P1*P2/h3) else None
let carms g = primes|>Seq.takeWhile(fun n->n<=g)|>Seq.collect fN|>Seq.choose fG
carms 61 |> Seq.iter (fun (P1,P2,P3)->printfn "%2d x %4d x %5d = %10d" P1 P2 P3 ((uint64 P3)*(uint64 (P1*P2))))
