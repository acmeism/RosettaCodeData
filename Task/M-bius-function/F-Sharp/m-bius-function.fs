// Möbius function. Nigel Galloway: January 31st., 2021
let fN g=let n=primes32()
         let rec fN i g e l=match (l/g,l%g,e) with (1,0,false)->i
                                                  |(n,0,false)->fN (0-i) g true n
                                                  |(_,0,true) ->0
                                                  |_          ->fN i (Seq.head n) false l
         fN -1 (Seq.head n) false g
let mobius=seq{yield 1; yield! Seq.initInfinite((+)2>>fN)}
mobius|>Seq.take 500|>Seq.chunkBySize 25|>Seq.iter(fun n->Array.iter(printf "%3d") n;printfn "")
