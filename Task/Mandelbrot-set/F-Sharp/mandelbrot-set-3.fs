getMandelbrotValues 80 25 50 ((-2.0,1.0),(-1.0,1.0))
|> List.map(fun row-> row |> List.map (function | 0 ->" " |_->".") |> String.concat "")
|> List.iter (printfn "%s")
