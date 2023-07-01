let rec agm a g precision  =
    if precision > abs(a - g) then a else
    agm (0.5 * (a + g)) (sqrt (a * g)) precision

printfn "%g" (agm 1. (sqrt(0.5)) 1e-15)
