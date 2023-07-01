uT 2000|>Array.mapi(fun n g->(n,g))|>Array.filter(fun(_,n)->n)|>Array.chunkBySize 30|>Array.iter(fun n->n|>Array.iter(fst>>printf "%5d");printfn "")
