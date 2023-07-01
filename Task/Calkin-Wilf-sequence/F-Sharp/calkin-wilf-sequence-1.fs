// Calkin Wilf Sequence. Nigel Galloway: January 9th., 2021
let cW=Seq.unfold(fun(n)->Some(n,seq{for n,g in n do yield (n,n+g); yield (n+g,g)}))(seq[(1,1)])|>Seq.concat
