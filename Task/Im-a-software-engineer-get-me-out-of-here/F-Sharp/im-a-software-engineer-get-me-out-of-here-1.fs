let safety=readCSV '\t' "gmooh.dat"|>Seq.choose(fun n->if n.value="0" then Some (n.row,n.col) else None)
let board=readCSV '\t' "gmooh.dat"|>Seq.choose(fun n->match n.value with |"0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9" as g->Some((n.row,n.col),int g)|_->None)|>Map.ofSeq
let adjacent((n,g),v)=List.choose(fun y->if y=(n,g) then None else match Map.tryFind y board with |None->None|_->Some ((y),1)) [(n+v,g);(n-v,g);(n,g+v);(n,g-v);(n+v,g+v);(n+v,g-v);(n-v,g+v);(n-v,g-v);]
let adjacencyList=new System.Collections.Generic.Dictionary<(int*int),list<(int*int)*int>>()
let rec mkAdj start=
  let n=((start),Map.find start board)
  let g=adjacent n
  adjacencyList.Add((fst n),g)
  List.iter(fun ((n),_)->if (not (adjacencyList.ContainsKey n )) then mkAdj n) g
mkAdj (11,11)
let nodes=adjacencyList.Keys |> List.ofSeq
let G=nodes |>List.collect(fun n->List.map(fun (n',g)->(((n),(n')),g))(adjacencyList.Item n))|>Map.ofList
let paths=Dijkstra nodes G (11,11)
let _,res=safety|>Seq.choose(fun n->paths n) |> Seq.groupBy(fun n->List.length n)|>Seq.minBy fst
res |> Seq.iter (printfn "%A")
