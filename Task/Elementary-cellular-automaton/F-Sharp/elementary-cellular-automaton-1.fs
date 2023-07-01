// Elementary Cellular Automaton . Nigel Galloway: July 31st., 2019
let eca N=
  let N=Array.init 8 (fun n->(N>>>n)%2)
  Seq.unfold(fun G->Some(G,[|yield Array.last G; yield! G; yield Array.head G|]|>Array.windowed 3|>Array.map(fun n->N.[n.[2]+2*n.[1]+4*n.[0]])))
