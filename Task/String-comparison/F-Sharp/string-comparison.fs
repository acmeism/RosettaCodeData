open System

// self defined operators for case insensitive comparison
let (<~) a b  = String.Compare(a, b, StringComparison.OrdinalIgnoreCase) < 0
let (<=~) a b = String.Compare(a, b, StringComparison.OrdinalIgnoreCase) <= 0
let (>~) a b  = String.Compare(a, b, StringComparison.OrdinalIgnoreCase) > 0
let (>=~) a b = String.Compare(a, b, StringComparison.OrdinalIgnoreCase) >= 0
let (=~) a b  = String.Compare(a, b, StringComparison.OrdinalIgnoreCase) = 0
let (<>~) a b = String.Compare(a, b, StringComparison.OrdinalIgnoreCase) <> 0

let compare a b =   // standard operators:
    if a <  b then printfn "%s is strictly less than %s" a b
    if a <= b then printfn "%s is less than or equal to %s" a b
    if a >  b then printfn "%s is strictly greater than %s" a b
    if a >= b then printfn "%s is greater than or equal to %s" a b
    if a =  b then printfn "%s is equal to %s" a b
    if a <> b then printfn "%s is not equal to %s" a b
    // and our case insensitive self defined operators:
    if a <~  b then printfn "%s is strictly less than %s (case insensitive)" a b
    if a <=~ b then printfn "%s is less than or equal to %s (case insensitive)" a b
    if a >~  b then printfn "%s is strictly greater than %s (case insensitive)" a b
    if a >=~ b then printfn "%s is greater than or equal to %s (case insensitive)" a b
    if a =~  b then printfn "%s is equal to %s (case insensitive)" a b
    if a <>~ b then printfn "%s is not equal to %s (case insensitive)" a b


[<EntryPoint>]
let main argv =
    compare "YUP" "YUP"
    compare "BALL" "BELL"
    compare "24" "123"
    compare "BELL" "bELL"
    0
