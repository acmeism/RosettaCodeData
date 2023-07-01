open System

[<EntryPoint>]
let main _ =
    let maxIt = 13
    let maxItJ = 10
    let mutable a1 = 1.0
    let mutable a2 = 0.0
    let mutable d1 = 3.2
    Console.WriteLine(" i       d")
    for i in 2 .. maxIt do
        let mutable a = a1 + (a1 - a2) / d1
        for j in 1 .. maxItJ do
            let mutable x = 0.0
            let mutable y = 0.0
            for _ in 1 .. (1 <<< i) do
                y <- 1.0 - 2.0 * y * x
                x <- a - x * x
            a <- a - x / y
        let d = (a1 - a2) / (a - a1)
        Console.WriteLine("{0,2:d}    {1:f8}", i, d)
        d1 <- d
        a2 <- a1
        a1 <- a
    0 // return an integer exit code
