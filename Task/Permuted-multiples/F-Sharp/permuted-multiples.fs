// Permuted multiples. Nigel Galloway: August 18th., 2021
let fG n g=let rec fN g=[if g>0 then yield g%10; yield! fN(g/10)] in List.sort(fN n)=List.sort(fN g)
let n=Seq.initInfinite((+)2)|>Seq.collect(fun n->seq{(pown 10 n)+2..3..(pown 10 (n+1))/6})|>Seq.find(fun g->let fN=fG g in fN(g*2)&&fN(g*3)&&fN(g*4)&&fN(g*5)&&fN(g*6))
printfn $"The solution to Project Euler 52 is %d{n}"
