// Smallest number: Nigel Galloway. April 13th., 2021
let rec fG n g=match bigint.DivRem(n,if g<10 then 10I else 100I) with (_,n) when (int n)=g->true |(n,_) when n=0I->false |(n,_)->fG n g
{0..50}|>Seq.iter(fun g->printf "%d " (1+({1..0x0FFFFFFF}|>Seq.map(fun n->(bigint n)**n)|>Seq.findIndex(fun n->fG n g)))); printfn ""
