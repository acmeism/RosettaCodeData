let dot_product (a:array<'a>) (b:array<'a>) =
    if Array.length a <> Array.length b then failwith "invalid argument: vectors must have the same lengths"
    Array.fold2 (fun acc i j -> acc + (i * j)) 0 a b
