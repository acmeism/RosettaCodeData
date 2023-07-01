let detectDivideZero (x : int) (y : int):int option =
    try
        Some(x / y)
    with
        | :? System.ArithmeticException -> None


printfn "12 divided by 3 is %A" (detectDivideZero 12 3)
printfn "1 divided by 0 is %A" (detectDivideZero 1 0)
