// Multi-base primes. Nigel Galloway: July 4th., 2021
let digits="0123456789abcdefghijklmnopqrstuvwxyz"
let fG n g=let rec fN g=function i when i<n->i::g |i->fN((i%n)::g)(i/n) in primes32()|>Seq.skipWhile((>)(pown n (g-1)))|>Seq.takeWhile((>)(pown n g))|>Seq.map(fun g->(n,fN [] g))
let fN g={2..36}|>Seq.collect(fun n->fG n g)|>Seq.groupBy snd|>Seq.groupBy(snd>>(Seq.length))|>Seq.maxBy fst
{1..4}|>Seq.iter(fun g->let n,i=fN g in printfn "The following strings of length %d represent primes in the maximum number of bases(%d):" g n
                        i|>Seq.iter(fun(n,g)->printf "  %s->" (n|>List.map(fun n->digits.[n])|>Array.ofList|>System.String)
                                              g|>Seq.iter(fun(g,_)->printf "%d " g); printfn ""); printfn "")
