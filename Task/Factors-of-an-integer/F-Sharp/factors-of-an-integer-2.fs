[6;120;2048;402642;1206432] |> Seq.iter(fun n->printf "%d :" n; [1..n]|>Seq.filter(fun g->n%g=0)|>Seq.iter(fun n->printf " %d" n); printfn "");;
