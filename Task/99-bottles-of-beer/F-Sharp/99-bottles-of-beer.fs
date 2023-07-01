#light
let rec bottles n =
    let (before, after) = match n with
                          | 1 -> ("bottle", "bottles")
                          | 2 -> ("bottles", "bottle")
                          | n -> ("bottles", "bottles")
    printfn "%d %s of beer on the wall" n before
    printfn "%d %s of beer" n before
    printfn "Take one down, pass it around"
    printfn "%d %s of beer on the wall\n" (n - 1) after
    if n > 1 then
        bottles (n - 1)
