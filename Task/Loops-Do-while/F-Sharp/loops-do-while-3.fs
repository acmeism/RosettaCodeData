// Loops/Do-while. Nigel Galloway: February 14th., 2022
Seq.unfold(fun n->match n with Some n->let n=n+1 in Some(n,if n%6=0 then None else Some(n)) |_->None)(Some 0)|>Seq.iter(printfn "%d")
