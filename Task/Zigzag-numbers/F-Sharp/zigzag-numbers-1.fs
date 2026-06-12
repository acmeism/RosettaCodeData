// Generate Zigzag numbers. Nigel Galloway: September 11th., 2025
let rec fN i g e l=
  match i,i|>List.filter ((if (List.length l)%2=0 then (>) else (<))g) with
     _,[]->()
    |[x],[i]->e(i::l)
    |_,n->n|>List.iter(fun n->fN(i|>List.except [n]) n e (n::l))
[2..5]|>List.iter(fun g->let g=[1..g] in printf "%A->" g; g|>List.iter(fun n->fN(g|>List.except [n]) n (List.rev>>printf "%A") [n]); printfn "")
printfn "\nCount of solutions:-"
[2..14]|>List.iter(fun g->let g=[1..g] in printf "%A->" g; let mutable q=0 in g|>List.iter(fun n->fN(g|>List.except [n]) n (fun _->q<-q+1) [n]); printfn "%d" q)
