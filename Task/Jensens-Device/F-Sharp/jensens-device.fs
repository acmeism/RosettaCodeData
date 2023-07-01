printfn "%.14f" (List.fold(fun n g->n+1.0/g) 0.0 [1.0..100.0]);;
