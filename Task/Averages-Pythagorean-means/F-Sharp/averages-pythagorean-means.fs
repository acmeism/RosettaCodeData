let P = [1.0; 2.0; 3.0; 4.0; 5.0; 6.0; 7.0; 8.0; 9.0; 10.0]

let arithmeticMean (x : float list) =
    x |> List.sum
      |> (fun acc -> acc / float (List.length(x)))

let geometricMean (x: float list) =
    x |> List.reduce (*)
      |> (fun acc -> Math.Pow(acc, 1.0 / (float (List.length(x)))))

let harmonicMean (x: float list) =
    x |> List.map (fun a -> 1.0 / a)
      |> List.sum
      |> (fun acc -> float (List.length(x)) / acc)

printfn "Arithmetic Mean: %A" (arithmeticMean P)
printfn "Geometric Mean: %A" (geometricMean P)
printfn "Harmonic Mean: %A" (harmonicMean P)
