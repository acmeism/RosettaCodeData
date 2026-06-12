let bin n g=[1..g]|>List.fold(fun z g->z*(n-g+1)/g) 1
[1..20]|>List.iter(fun g->printf "%d "((bin g 4)+(bin g 2)+1)); printfn ""
