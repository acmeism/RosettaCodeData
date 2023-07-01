let stripComments s =
    s
    |> Seq.takeWhile (fun c -> c <> '#' && c <> ';')
    |> Seq.map System.Char.ToString
    |> Seq.fold (+) ""
