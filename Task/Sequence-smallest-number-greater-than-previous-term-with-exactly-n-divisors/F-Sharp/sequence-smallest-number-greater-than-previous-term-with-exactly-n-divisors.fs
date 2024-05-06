// Nigel Galloway: November 19th., 2017
let fN g=[1..(float>>sqrt>>int)g]|>List.fold(fun Σ n->if g%n>0 then Σ else if g/n=n then Σ+1 else Σ+2) 0
let A069654=let rec fG n g=seq{match g-fN n with 0->yield n; yield! fG(n+1)(g+1) |_->yield! fG(n+1)g} in fG 1 1

A069654 |> Seq.take 28|>Seq.iter(printf "%d "); printfn ""
