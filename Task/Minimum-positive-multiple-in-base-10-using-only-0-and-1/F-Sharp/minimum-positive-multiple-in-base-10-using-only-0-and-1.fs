// Minimum positive multiple in base 10 using only 0 and 1. Nigel Galloway: March 9th., 2020
let rec fN Σ n i g e l=if l=1||n=1 then Σ+1I else
                       match (10*i)%l with
                        g when n=g->Σ+10I**e
                       |i->match Set.map(fun n->(n+i)%l) g with
                            ф when ф.Contains n->fN (Σ+10I**e) ((l+n-i)%l) 1 (set[1]) 1 l
                           |ф->fN Σ n i (Set.unionMany [set[i];g;ф]) (e+1) l

let B10=fN 0I 0 1 (set[1]) 1
List.concat[[1..10];[95..105];[297;576;594;891;909;999;1998;2079;2251;2277;2439;2997;4878]]
|>List.iter(fun n->let g=B10 n in printfn "%d * %A = %A" n (g/bigint(n)) g)
