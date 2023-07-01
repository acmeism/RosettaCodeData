open System

let fibonacci = Seq.unfold (fun (x, y) -> Some(x, (y, x + y))) (0I,1I)
let fibFirstNumbers nth =
    fibonacci |> Seq.take nth |> Seq.map (fun n -> n.ToString().[0] |> string |> Int32.Parse)

let fibFirstNumbersFrequency nth =
    let firstNumbers = fibFirstNumbers nth |> Seq.toList
    let counts = firstNumbers |> List.countBy id |> List.sort |> List.filter (fun (k, _) -> k <> 0)
    let total = firstNumbers |> List.length |> float
    counts |> List.map (fun (_, v) -> float v/total)

let benfordLaw d = log10(1.0 + (1.0/float d))
let benfordLawFigures = [1..9] |> List.map benfordLaw

let run () =
    printfn "Frequency of the first digit (1 through 9) in the Fibonacci sequence:"
    fibFirstNumbersFrequency 1000 |> List.iter (fun f -> printf $"{f:N5} ")
    printfn "\nBenford's law for 1 through 9:"
    benfordLawFigures |> List.iter (fun f -> printf $"{f:N5} ")
