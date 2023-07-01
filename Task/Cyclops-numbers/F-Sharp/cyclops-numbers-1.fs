// Cyclop numbers. Nigel Galloway: June 25th., 2021
let rec fG n g=seq{yield! g|>Seq.collect(fun i->g|>Seq.map(fun g->n*i+g)); yield! fG(n*10)(fN g)}
let cyclops=seq{yield 0; yield! fG 100 [1..9]}
let primeCyclops,blindCyclops=cyclops|>Seq.filter isPrime,Seq.zip(fG 100 [1..9])(fG 10 [1..9])|>Seq.filter(fun(n,g)->isPrime n && isPrime g)|>Seq.map fst
let palindromicCyclops=let fN g=let rec fN g=[yield g%10; if g>9 then yield! fN(g/10)] in let n=fN g in n=List.rev n in primeCyclops|>Seq.filter fN
