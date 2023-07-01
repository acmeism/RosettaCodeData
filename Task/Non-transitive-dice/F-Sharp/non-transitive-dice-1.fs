// Non-transitive dice. Nigel Galloway: August 9th., 2020
let die=[for n0 in [1..4] do for n1 in [n0..4] do for n2 in [n1..4] do for n3 in [n2..4]->[n0;n1;n2;n3]]
let N=seq{for n in die->(n,[for g in die do if (seq{for n in n do for g in g->compare n g}|>Seq.sum<0) then yield g])}|>Map.ofSeq
let n3=seq{for d1 in die do for d2 in N.[d1] do for d3 in N.[d2] do if List.contains d1 N.[d3] then yield (d1,d2,d3)}
let n4=seq{for d1 in die do for d2 in N.[d1] do for d3 in N.[d2] do for d4 in N.[d3] do if List.contains d1 N.[d4] then yield (d1,d2,d3,d4)}
n3|>Seq.iter(fun(d1,d2,d3)->printfn "%A<%A; %A<%A; %A>%A\n" d1 d2 d2 d3 d1 d3)
n4|>Seq.iter(fun(d1,d2,d3,d4)->printfn "%A<%A; %A<%A; %A<%A; %A>%A" d1 d2 d2 d3 d3 d4 d1 d4)
