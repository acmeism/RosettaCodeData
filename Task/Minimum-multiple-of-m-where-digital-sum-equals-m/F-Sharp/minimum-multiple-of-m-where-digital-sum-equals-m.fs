// Minimum multiple of m where digital sum equals m. Nigel Galloway: January 31st., 2022
let SoD n=let rec SoD n=function 0L->int n |g->SoD(n+g%10L)(g/10L) in SoD 0L n
let A131382(g:int)=let rec fN i=match SoD(i*int64(g)) with
                                 n when n=g -> i
                                |n when n>g -> fN (i+1L)
                                |n -> fN (i+(int64(ceil(float(g-n)/float n))))
                   fN ((((pown 10L (g/9))-1L)+int64(g%9)*(pown 10L (g/9)))/int64 g)
Seq.initInfinite((+)1>>A131382)|>Seq.take 70|>Seq.chunkBySize 10|>Seq.iter(fun n->n|>Seq.iter(printf "%13d "); printfn "")
