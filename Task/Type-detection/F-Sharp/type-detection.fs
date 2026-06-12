printfn "%A" (3.14.GetType())
let inline fN g=g.GetType()|>string
printfn "%s" (fN "Nigel")
printfn "%s" (fN 23)
