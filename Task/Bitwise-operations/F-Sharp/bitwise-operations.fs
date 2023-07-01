let bitwise a b =
    printfn "a and b: %d" (a &&& b)
    printfn "a or  b: %d" (a ||| b)
    printfn "a xor b: %d" (a ^^^ b)
    printfn "not a: %d"   (~~~a)
    printfn "a shl b: %d" (a <<< b)
    printfn "a shr b: %d" (a >>> b)          // arithmetic shift
    printfn "a shr b: %d" ((uint32 a) >>> b) // logical shift
    // No rotation operators.
