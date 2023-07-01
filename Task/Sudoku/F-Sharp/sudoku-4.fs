open System
open SudokuCPSArray
open System.Diagnostics
open System.IO

[<EntryPoint>]
let main argv =
     printfn "Easy board solution automatic with constraint propagation"
     let easy = "..3.2.6..9..3.5..1..18.64....81.29..7.......8..67.82....26.95..8..2.3..9..5.1.3.."
     easy |> solveNoSearch |> printfn "%s"

     printfn "Simple elimination not possible"
     let simple = "4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......"
     simple |> run "Parse Error" asString id |> printfn "%s"
     simple |> solveNoSearch |> printfn "%s"

     printfn "Try again with search:"
     simple |> solveWithSearch |> printfn "%s"

     let watch = Stopwatch()

     let hard = "85...24..72......9..4.........1.7..23.5...9...4...........8..7..17..........36.4."
     printfn "Hard"
     watch.Start()
     hard |> solveWithSearch |> printfn "%s"
     watch.Stop()
     printfn $"Elapsed milliseconds = {watch.ElapsedMilliseconds } ms"
     watch.Reset()

     let puzzles  =
        if Seq.length argv = 1 then
            let num = argv[0] |> int
            printfn $"First {num} puzzles in sudoku17 (http://staffhome.ecm.uwa.edu.au/~00013890/sudoku17)"
            File.ReadLines(@"sudoku17.txt") |> Seq.take num |>Array.ofSeq
        else
            printfn $"All puzzles in sudoku17 (http://staffhome.ecm.uwa.edu.au/~00013890/sudoku17)"
            File.ReadLines(@"sudoku17.txt") |>Array.ofSeq
     watch.Start()
     let result = puzzles |> Array.map solveWithSearchToMapOnly
     watch.Stop()
     if result |> Seq.forall Option.isSome then
        let total = watch.ElapsedMilliseconds
        let avg = (float total) /(float result.Length)
        printfn $"\nPuzzles:{result.Length}, Total:%.2f{((float)total)/1000.0} s, Average:%.2f{avg} ms"
     else
        printfn "Some sudoku17 puzzles failed"
     Console.ReadKey() |> ignore
     0
