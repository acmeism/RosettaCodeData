// Sum digits of n is substring of n: Nigel Galloway. April 16th., 2021
let rec fG n g=match (n/10,n%(if g<10 then 10 else 100)) with (_,n) when n=g->true |(0,_)->false |(n,_)->fG n g
let rec fN g=function n when n<10->n+g |n->fN(g+n%10)(n/10)
{1..999}|>Seq.filter(fun n->fG n (fN 0 n))|>Seq.iter(printf "%d "); printfn ""
