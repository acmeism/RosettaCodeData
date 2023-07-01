// Population count. Nigel Galloway: February 18th., 2021
let pC n=Seq.unfold(fun n->match n/2L,n%2L with (0L,0L)->None |(n,g)->Some(g,n))n|>Seq.sum
printf "pow3  :"; [0..29]|>List.iter((pown 3L)>>pC>>(printf "%3d")); printfn ""
printf "evil  :"; Seq.initInfinite(int64)|>Seq.filter(fun n->(pC n) &&& 1L=0L)|>Seq.take 30|>Seq.iter(printf "%3d"); printfn ""
printf "odious:"; Seq.initInfinite(int64)|>Seq.filter(fun n->(pC n) &&& 1L=1L)|>Seq.take 30|>Seq.iter(printf "%3d"); printfn ""
