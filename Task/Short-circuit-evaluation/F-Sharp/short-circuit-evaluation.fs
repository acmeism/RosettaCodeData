let a (x : bool) = printf "(a)"; x
let b (x : bool) = printf "(b)"; x

[for x in [true; false] do for y in [true; false] do yield (x, y)]
|> List.iter (fun (x, y) ->
    printfn "%b AND %b = %b" x y ((a x) && (b y))
    printfn "%b OR %b = %b" x y ((a x) || (b y)))
