// Common sorted list. Nigel Galloway: February 25th., 2021
let nums=[|[5;1;3;8;9;4;8;7];[3;5;9;8;4];[1;3;7;9]|]
printfn "%A" (nums|>Array.reduce(fun n g->n@g)|>List.distinct|>List.sort)
