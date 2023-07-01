// Odd and Even Lucky Numbers. Nigel Galloway: October 3rd., 2020
let rec fN i g e l=seq{yield! i|>Seq.skip g|>Seq.take(e-g-1)
                       let n=Seq.chunkBySize e i|>Seq.collect(Seq.take(e-1)) in yield! fN n (e-1) (Seq.item l n) (l+1)}
let oLuck,eLuck=let rec fG g=seq{yield g; yield! fG(g+2)} in (fN(fG 1) 0 3 2,fN(fG 2) 0 4 2)
