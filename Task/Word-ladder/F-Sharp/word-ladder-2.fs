[("evil","good");("god","man")]|>List.iter(fun(n,g)->printfn "%s" (match wL n g with Some n->n|>String.concat " -> " |_->n+" into "+g+" can't be done"))
