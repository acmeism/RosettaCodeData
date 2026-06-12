//Sub-unit squares. Nigel Galloway: March 4th., 2026
let dr=[|[1UL;4UL;7UL;9UL];[1UL];[9UL];[1UL;4UL;7UL];[4UL];[9UL];[1UL;4UL;7UL];[7UL];[9UL]|]
let start numD dr=((pown 10UL numD)-1UL)/9UL+dr-uint64(numD%9)
let rec zFree n=match System.Math.DivRem(n,10UL)
                with _,0UL->false |0UL,_->true |n,_->zFree n
let izSq (n:uint64)=let g=sqrt(float n)|>uint64 in n=g*g
let rec fG n g=seq{let r=n*100UL+36UL in if zFree n && izSq r then yield r
                   let n=n+9UL in if n<g then yield! fG n g}
let fN numD=
  let s=((pown 10UL numD)-1UL)/9UL
  dr[numD%9]|>Seq.collect(fun n->fG(start(numD-2) n)(pown 10UL(numD-2))|>Seq.filter(fun n->izSq(n-s)))
seq{yield 1UL; yield 36UL; yield! Seq.initInfinite((+)3)|>Seq.collect(fun g->fN g)}|>Seq.iter(printfn "%d")
