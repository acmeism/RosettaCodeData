[2..16]|>List.iter(fun n->printfn "\nBase %d" n; Esthetic n|>Seq.skip(4*n-1)|>Seq.take((6-4)*n+1)|>Seq.iter(EtoS >> printfn "%s"))
