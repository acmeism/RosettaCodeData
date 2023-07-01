// Sum below leading diagnal. Nigel Galloway: July 21st., 2021
let _,n=[[ 1; 3; 7; 8;10];
         [ 2; 4;16;14; 4];
         [ 3; 1; 9;18;11];
         [12;14;17;18;20];
         [ 7; 1; 3; 9; 5]]|>List.fold(fun(n,g) i->let i,_=i|>List.splitAt n in (n+1,g+(i|>List.sum)))(0,0) in printfn "%d" n
