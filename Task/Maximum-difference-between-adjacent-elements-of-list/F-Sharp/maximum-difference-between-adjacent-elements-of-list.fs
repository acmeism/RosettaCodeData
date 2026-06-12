// Max diff 'twix adj elems. Nigel Galloway: July 18th., 2021
let n,g=[1;8;2;-3;0;1;1;-2;3;0;5;5;8;6;2;9;11;10;3]|>List.pairwise|>List.groupBy(fun(n,g)->abs(n-g))|>List.maxBy fst in printfn "Pairs %A have the max diff of %d" g n
