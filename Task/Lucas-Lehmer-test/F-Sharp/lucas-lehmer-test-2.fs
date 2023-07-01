let IsMersennePrime exponent =
    if exponent <= 1 then failwith "Exponent must be >= 2"
    let prime = 2I ** exponent - 1I;

    let rec LucasLehmer i acc =
        match i with
        | x when x = exponent - 2 -> acc
        | x -> LucasLehmer (x + 1) ((acc*acc - 2I) % prime)

    LucasLehmer 0 4I = 0I
