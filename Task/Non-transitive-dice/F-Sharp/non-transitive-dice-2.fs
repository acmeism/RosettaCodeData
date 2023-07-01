// Non-transitive diceNigel Galloway: August 9th., 2020
let die=[for n0 in [1..6] do for n1 in [n0..6] do for n2 in [n1..6] do for n3 in [n2..6] do for n4 in [n3..6] do for n5 in [n4..6]->[n0;n1;n2;n3;n4;n5]]
let N=seq{for n in die->(n,[for g in die do if (seq{for n in n do for g in g->compare n g}|>Seq.sum<0) then yield g])}|>Map.ofSeq
let n3=[for d1 in die do for d2 in N.[d1] do for d3 in N.[d2] do if List.contains d1 N.[d3] then yield (d1,d2,d3)]
let d1,d2,d3=List.last n3 in printfn "Solutions found = %d\nLast solution found is %A<%A; %A<%A; %A>%A" (n3.Length) d1 d2 d2 d3 d1 d3
