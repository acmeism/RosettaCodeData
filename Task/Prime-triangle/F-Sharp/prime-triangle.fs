// Prime triangle. Nigel Galloway: April 12th., 2022
let     fN i (g,(e,l))=e|>Seq.map(fun n->let n=i n in (n::g,List.partition(i>>(=)n) l))
let rec fG n g=function 0->n|>Seq.map fst |x->fG(n|>Seq.collect(fN(if g then fst else snd)))(not g)(x-1)
let primeT row=fG [([1],([for g in {2..2..row-1} do if isPrime(g+1) then yield (1,g)],[for n in {3..2..row-1} do for g in {2..2..row-1} do if isPrime(n+g) then yield (n,g)]))] false (row-2)
                 |>Seq.filter(List.head>>(+)row>>isPrime)|>Seq.map(fun n->row::n|>List.rev)

{2..20}|>Seq.iter(fun n->(primeT>>Seq.head>>List.iter(printf "%3d"))n;printfn "");;
{2..20}|>Seq.iter(primeT>>Seq.length>>printf "%d "); printfn ""
