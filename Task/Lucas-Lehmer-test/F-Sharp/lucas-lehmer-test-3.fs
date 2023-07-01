let IsMersennePrime exponent =
    if exponent <= 1 then failwith "Exponent must be >= 2"
    let prime = 2I ** exponent - 1I;

    let LucasLehmer =
        [| 1 .. exponent-2 |] |> Array.fold (fun acc _ -> (acc*acc - 2I) % prime) 4I

    LucasLehmer = 0I
