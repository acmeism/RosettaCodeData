// Consistent overhead byte stuffing. Nigel Galloway: September 28th., 20
let rec fN g=if Seq.isEmpty g then Seq.empty else let n,_=g|>Seq.indexed|>Seq.find(fun(n,g)->n>253 || g=0uy)
                                                  seq{match n with 254->yield 255uy; yield!(g|>Seq.take 254); yield! fN(g|>Seq.skip 254)
                                                                  |n->yield byte(n+1); yield!(g|>Seq.take n); yield! fN(g|>Seq.skip(n+1))}
let encode g=seq{yield! fN(seq{yield! g; yield 0uy}); yield 0uy}
let fI n=if n then [0uy] else []
let rec fG n g=seq{match Seq.head g with 0uy->() |255uy->yield! fI n; yield! g|>Seq.take 255|>Seq.skip 1; yield! fG false (g|>Seq.skip 255)
                                        |i->yield! fI n; yield! g|>Seq.take(int i)|>Seq.skip 1; yield! fG true (g|>Seq.skip(int i))}
let decode g=fG false g
