// Anaprimes. Nigel Galloway: February 2nd., 2023
let fN g=let i=Array.zeroCreate<int>10
         let rec fN g=if g<10 then i[g]<-i[g]+1 else i[g%10]<-i[g%10]+1; fN (g/10)
         fN g; i
let aP n=let _,n=primes32()|>Seq.skipWhile((>)(pown 10 (n-1)))|>Seq.takeWhile((>)(pown 10 n-1))|>Seq.groupBy fN|>Seq.maxBy(fun(_,n)->Seq.length n)
         let n=Array.ofSeq n
         (n.Length,Array.min n,Array.max n)
[3..9]|>List.map aP|>List.iteri(fun i (n,g,l)->printfn $"%d{i+3} digits: Count=%d{n} Min=%d{g} Max=%d{l}")
