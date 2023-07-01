let toFloat x = x |> int |> fun n -> n - 48 |> float
let power x = toFloat x ** toFloat x |> int
let isMunchausen n = n = (string n |> Seq.map char |> Seq.map power |> Seq.sum)

printfn "%A" ([1..5000] |> List.filter isMunchausen)
