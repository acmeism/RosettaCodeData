let primes max =
    let mutable xs = [|2..max|]
    let limit = max |> float |> sqrt |> int
    for x in [|2..limit|] do
        xs <- xs |> Array.except [|x*x..x..max|]
    xs
