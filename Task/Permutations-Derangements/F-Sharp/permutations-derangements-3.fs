let subFact n=let rec fN n g=match n with 0m->int64(round(g/2.7182818284590452353602874713526624978m))|_->fN (n-1m) (g*n) in if n=0 then 1L else fN (decimal n) 1m
[1..9] |> Seq.iter(fun n->printfn "items=%d !n=%d derangements=%d" n (subFact n) (derange n|>Seq.length))
