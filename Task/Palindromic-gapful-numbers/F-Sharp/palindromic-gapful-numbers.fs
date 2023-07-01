// Palindromic Gapful Numbers . Nigel Galloway: December 3rd., 2020
let rec fN g l=seq{match l with 3->yield! seq{for n in 0L..9L->g*100L+g+n*10L}
                               |4->yield! seq{for n in 0L..9L->g*1000L+g+n*110L}
                               |_->yield! seq{for n in 0L..9L do for i in fN n (l-2)->i*10L+g+g*(pown 10L (l-1))}}

let rcGf n=let rec rcGf g=seq{yield! fN n g|>Seq.filter(fun g->g%(10L*n+n)=0L); yield! rcGf(g+1)} in rcGf 3

[1L..9L]|>Seq.iter(fun n->rcGf n|>Seq.take 20|>Seq.iter(printf "%d ");printfn "");printfn "#####"
[1L..9L]|>Seq.iter(fun n->rcGf n|>Seq.skip 85|>Seq.take 15|>Seq.iter(printf "%d ");printfn "");printfn "#####"
[1L..9L]|>Seq.iter(fun n->rcGf n|>Seq.skip 990|>Seq.take 10|>Seq.iter(printf "%d ");printfn "");printfn "#####"
