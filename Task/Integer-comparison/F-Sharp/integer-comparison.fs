let compare_ints a b =
    let r =
        match a with
        | x when x < b -> -1, printfn "%d is less than %d" x b
        | x when x = b -> 0,  printfn "%d is equal to %d" x b
        | x when x > b -> 1,  printfn "%d is greater than %d" x b
        | x -> 0, printf "default condition (not reached)"
    fst r
