let sl : string list = [null; "abc"]

let f s =
    match s with
    | null -> "It is null!"
    | _ -> "It's non-null: " + s

for s in sl do printfn "%s" (f s)
