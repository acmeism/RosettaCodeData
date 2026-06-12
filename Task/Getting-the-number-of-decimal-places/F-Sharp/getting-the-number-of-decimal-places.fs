//Getting the number of decimal places. Nigel Galloway: March 23rd., 2023.
let fN g=let n,g=Seq.length g,g|>Seq.tryFindIndex((=)'.') in match g with Some g->n-g-1 |_->0
["12";"12.00";"12.345";"12.3450";"12.34500"]|>List.iter(fN>>printfn "%d")
