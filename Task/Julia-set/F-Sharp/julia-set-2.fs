getJuliaValues 80 25 -0.7 0.27015 1.0 50
|> List.map(fun row-> row |> List.map (function | 0 ->" " |_->".") |> String.concat "")
|> List.iter (printfn "%s")
