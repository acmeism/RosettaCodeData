open System
open SudokuBacktrack

[<EntryPoint>]
let main argv =
     let puzzle =  "000028000800010000000000700000600403200004000100700000030400500000000010060000000"
     puzzle |> printfn "Puzzle:\n%s"
     puzzle |> parseGrid |> prettyPrint |> printfn "Formatted:\n%s"
     puzzle |> solve |> prettyPrint |> printfn "Solution:\n%s"

     printfn "Press any key to exit"
     Console.ReadKey() |> ignore
     0
