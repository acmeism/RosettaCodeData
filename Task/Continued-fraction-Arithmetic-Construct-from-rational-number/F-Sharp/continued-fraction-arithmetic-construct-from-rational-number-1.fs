let rec r2cf n d =
    if d = LanguagePrimitives.GenericZero then []
    else let q = n / d in q :: (r2cf d (n - q * d))

[<EntryPoint>]
let main argv =
    printfn "%A" (r2cf 1 2)
    printfn "%A" (r2cf 3 1)
    printfn "%A" (r2cf 23 8)
    printfn "%A" (r2cf 13 11)
    printfn "%A" (r2cf 22 7)
    printfn "%A" (r2cf -151 77)
    printfn "%A" (r2cf 141 100)
    printfn "%A" (r2cf 1414 1000)
    printfn "%A" (r2cf 14142 10000)
    printfn "%A" (r2cf 141421 100000)
    printfn "%A" (r2cf 1414214 1000000)
    printfn "%A" (r2cf 14142136 10000000)
    0
