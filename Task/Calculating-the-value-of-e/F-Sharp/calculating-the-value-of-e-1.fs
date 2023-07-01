// A function to generate the sequence 1/n!). Nigel Galloway: May 9th., 2018
let e = Seq.unfold(fun (n,g)->Some(n,(n/g,g+1N))) (1N,1N)
