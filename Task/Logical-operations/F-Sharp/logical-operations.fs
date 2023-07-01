let printLogic a b =
    printfn "a and b is %b" (a && b)
    printfn "a or b is %b" (a || b)
    printfn "Not a is %b" (not a)
    // The not-equals operator has the same effect as XOR on booleans.
    printfn "a exclusive-or b is %b" (a <> b)
