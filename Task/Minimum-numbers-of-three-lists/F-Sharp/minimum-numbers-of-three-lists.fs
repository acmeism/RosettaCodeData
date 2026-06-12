// Minimum numbers of three lists. Nigel Galloway: October 26th., 2021
let N1,N2,N3=[5;45;23;21;67],[43;22;78;46;38],[9;98;12;98;53]
printfn "%A" (List.zip3 N1 N2 N3|>List.map(fun(n,g,l)->min (min n g) l))
