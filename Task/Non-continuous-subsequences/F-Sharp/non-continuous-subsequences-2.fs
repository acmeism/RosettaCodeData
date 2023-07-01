let Ng ng = N ng |> Seq.iter(fun n->printf "%2d -> " n; {0..(ng-1)}|>Seq.iter (fun g->if (n&&&(1<<<g))>0 then printf "%d " (g+1));printfn "")
Ng 4
