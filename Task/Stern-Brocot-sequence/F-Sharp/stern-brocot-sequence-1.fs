// Generate Stern-Brocot Sequence. Nigel Galloway: October 11th., 2018
let sb=Seq.unfold(fun (n::g::t)->Some(n,[g]@t@[n+g;g]))[1;1]
