// Coprimes. Nigel Galloway: May 4th., 2021
let rec fN g=function 0->g=1 |n->fN n (g%n)
[(21,15);(17,23);(36,12);(18,29);(60,15)] |> List.filter(fun(n,g)->fN n g)|>List.iter(fun(n,g)->printfn "%d and %d are coprime" n g)
