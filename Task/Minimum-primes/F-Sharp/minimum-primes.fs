// Minimum primes. Nigel Galloway: October 29th., 2021
let N1,N2,N3=[5;45;23;21;67],[43;22;78;46;38],[9;98;12;54;53]
let fN g=primes32()|>Seq.find((<=)g)
printfn "%A" (List.zip3 N1 N2 N3|>List.map(fun(n,g,l)->fN(max (max n g) l)))
