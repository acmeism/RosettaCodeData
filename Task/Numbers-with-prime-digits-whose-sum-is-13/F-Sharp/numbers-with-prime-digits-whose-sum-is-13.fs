// prime digits whose sum is 13. Nigel Galloway: October 21st., 2020
let rec fN g=let g=[for n in [2;3;5;7] do for g in g->n::g]|>List.groupBy(fun n->match List.sum n with 13->'n' |n when n<12->'g' |_->'x')|>Map.ofSeq
             [yield! (if g.ContainsKey 'n' then g.['n'] else []); yield! (if g.ContainsKey 'g' then fN g.['g'] else [])]
fN [[]] |> Seq.iter(fun n->n|>List.iter(printf "%d");printf " ");printfn ""
