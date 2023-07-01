let rec mfact d = function
    | n when n <= d   -> n
    | n -> n * mfact d (n-d)

[<EntryPoint>]
let main argv =
    let (|UInt|_|) = System.UInt32.TryParse >> function | true, v -> Some v | false, _ -> None
    let (maxDegree, maxN) =
        match argv with
            | [| UInt d; UInt n |] -> (int d, int n)
            | [| UInt d |]         -> (int d, 10)
            | _                    -> (5, 10)
    let showFor d = List.init maxN (fun i -> mfact d (i+1)) |> printfn "%i: %A" d
    ignore (List.init maxDegree (fun i -> showFor (i+1)))
    0
