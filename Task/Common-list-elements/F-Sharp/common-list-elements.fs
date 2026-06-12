// Common list elements. Nigel Galloway: February 25th., 2021
let nums=[|[2;5;1;3;8;9;4;6];[3;5;6;2;9;8;4];[1;3;7;6;9]|]
printfn "%A" (nums|>Array.reduce(fun n g->n@g)|>List.distinct|>List.filter(fun n->nums|>Array.forall(fun g->List.contains n g)));;
