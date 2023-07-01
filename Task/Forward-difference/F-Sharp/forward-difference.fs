let rec ForwardDifference input n =
    match n with
    | _ when input = [] || n < 0 -> []      // If there's no more input, just return an empty list
    | 0 -> input                            // If n is zero, we're done - return the input
    | _ -> ForwardDifference                // otherwise, recursively difference..
            (input.Tail                     // All but the first element
            |> Seq.zip input                // tupled with itself
            |> Seq.map (fun (a, b) -> b-a)  // Subtract the i'th element from the (i+1)'th
            |> Seq.toList) (n-1)            // Make into a list and do an n-1 difference on it
