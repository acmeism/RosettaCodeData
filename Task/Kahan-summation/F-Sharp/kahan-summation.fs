let ε =
    let rec δ λ =
        match λ+1.0 with
        | 1.0 -> λ
        | _ -> δ(λ/2.0)
    δ(1.0)

let Σ numbers =
    let rec Σ numbers σ c =
        match numbers with
        | [] -> σ
        | number :: rest ->
            let y = number + c
            let t = σ + y
            let z = ((t - σ) - y)
            Σ rest t z
    Σ numbers 0.0 0.0

[<EntryPoint>]
let main argv =
    let (a, b, c) = ( 1.0, ε, -ε )
    let input = [ a; b; c ]
    printfn "ε:     %e" ε
    printfn "Sum:   %e" (input |> List.sum)
    printfn "Kahan: %e" (input |> Σ)
    0
