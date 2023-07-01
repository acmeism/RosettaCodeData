seq{(char)0..(char)127} |> Seq.filter(System.Char.IsUpper) |> Seq.iter (string >> printf "%s"); printfn ""
seq{(char)0..(char)127} |> Seq.filter(System.Char.IsLower) |> Seq.iter (string >> printf "%s"); printfn ""
