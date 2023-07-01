// Generate the fusc sequence. Nigel Galloway: March 20th., 2019
let fG n=seq{for (n,g) in Seq.append n [1] |> Seq.pairwise do yield n; yield n+g}
let fusc=seq{yield 0; yield! Seq.unfold(fun n->Some(n,fG n))(seq[1])|>Seq.concat}|> Seq.mapi(fun n g->(n,g))
