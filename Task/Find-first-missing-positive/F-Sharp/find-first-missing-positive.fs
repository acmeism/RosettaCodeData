// Find first missing positive. Nigel Galloway: February 15., 2021
let fN g=let g=0::g|>List.filter((<) -1)|>List.sort|>List.distinct
         match g|>List.pairwise|>List.tryFind(fun(n,g)->g>n+1) with Some(n,_)->n+1 |_->List.max g+1
[[1;2;0];[3;4;-1;1];[7;8;9;11;12]]|>List.iter(fN>>printf "%d "); printfn ""
