let board=readCSV '\t' "gmooh.dat"|>Seq.choose(fun n->match n.value with |"0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9" as g->Some((n.row,n.col),int g)|_->None)|>Map.ofSeq
let nodes=board|>Seq.map(fun n->n.Key)|>Set.ofSeq
let adjacent (n,g) v=List.choose(fun y->if y=(n,g) then None else match Set.contains y nodes with |true->Some ((y),1)|_->None) [(n+v,g);(n-v,g);(n,g+v);(n,g-v);(n+v,g+v);(n+v,g-v);(n-v,g+v);(n-v,g-v);]
let adjacencyList=board |>Seq.collect (fun n->Seq.map(fun ((n'),g')->((n.Key,n'),g'))(adjacent n.Key n.Value))|> Map.ofSeq
let _,paths=Floyd (nodes|>Set.toArray) adjacencyList
paths (21,11) (1,11) |>Seq.iteri(fun n g->if n>0 then printf "->"; printf "%A" g else printf "%A" g) ; printfn ""
paths (1,11) (21,11) |>Seq.iteri(fun n g->if n>0 then printf "->"; printf "%A" g else printf "%A" g) ; printfn ""
