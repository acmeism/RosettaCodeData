open System

let width = int( Console.ReadLine() )
let height = int( Console.ReadLine() )
let arr = Array2D.create width height 0
arr.[0,0] <- 42
printfn "%d" arr.[0,0]
