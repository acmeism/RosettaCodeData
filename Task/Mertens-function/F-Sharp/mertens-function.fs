// Mertens function. Nigel Galloway: January 31st., 2021
let mertens=mobius|>Seq.scan((+)) 0|>Seq.tail
mertens|>Seq.take 500|>Seq.chunkBySize 25|>Seq.iter(fun n->Array.iter(printf "%3d") n;printfn "\n####")
let n=mertens|>Seq.take 1000|>Seq.mapi(fun n g->(n+1,g))|>Seq.groupBy snd|>Map.ofSeq
n|>Map.iter(fun n g->printf "%3d->" n; g|>Seq.iter(fun(n,_)->printf "%3d " n); printfn "\n####")
printfn "%d Zeroes\n####" (Seq.length (snd n.[0]))
printfn "Crosses zero %d times" (mertens|>Seq.take 1000|>Seq.pairwise|>Seq.sumBy(fun(n,g)->if n<>0 && g=0 then 1 else 0)))
