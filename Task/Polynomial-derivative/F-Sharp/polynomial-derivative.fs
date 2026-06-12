// Polynomial derivative. Nigel Galloway: January 4th., 2023
let n=[[5];[4;-3];[-1;6;5];[-4;3;-2;1];[1;1;0;-1;-1]]|>List.iter((List.mapi(fun n g->n*g)>>List.skip 1>>printfn "%A"))
