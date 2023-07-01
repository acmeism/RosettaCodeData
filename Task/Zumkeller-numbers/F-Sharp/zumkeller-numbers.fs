// Zumkeller numbers: Nigel Galloway. May 16th., 2021
let rec fG n g=match g with h::_ when h>=n->h=n |h::t->fG n t || fG(n-h) t |_->false
let fN g=function n when n&&&1=1->false
                 |n->let e=n/2-g in match compare e 0 with 0->true
                                                          |1->let l=[1..e]|>List.filter(fun n->g%n=0)
                                                              match compare(l|>List.sum) e with 1->fG e l |0->true |_->false
                                                          |_->false
Seq.initInfinite((+)1)|>Seq.map(fun n->(n,sod n))|>Seq.filter(fun(n,g)->fN n g)|>Seq.take 220|>Seq.iter(fun(n,_)->printf "%d " n); printfn "\n"
Seq.initInfinite((*)2>>(+)1)|>Seq.map(fun n->(n,sod n))|>Seq.filter(fun(n,g)->fN n g)|>Seq.take 40|>Seq.iter(fun(n,_)->printf "%d " n); printfn "\n"
Seq.initInfinite((*)2>>(+)1)|>Seq.filter(fun n->n%10<>5)|>Seq.map(fun n->(n,sod n))|>Seq.filter(fun(n,g)->fN n g)|>Seq.take 40|>Seq.iter(fun(n,_)->printf "%d " n); printfn "\n"
