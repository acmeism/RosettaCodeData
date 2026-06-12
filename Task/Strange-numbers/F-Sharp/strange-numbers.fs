// Strange numbers. Nigel Galloway: February 25th., 2021
let N=Array.init 10(fun n->[2;3;5;7]|>List.collect(fun g->[n+g;n-g])|>List.filter((<) -1)|>List.filter((>)10))
[1..4]|>List.collect(fun g->N.[g]|>List.map(fun n->g*10+n%10))|>List.collect(fun n->N.[n%10]|>List.map(fun g->n*10+g%10))|>List.iter(printf "%d "); printfn ""
