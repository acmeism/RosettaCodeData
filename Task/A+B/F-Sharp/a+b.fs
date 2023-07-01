open System

let SumOf(str : string) =
    str.Split() |> Array.sumBy(int)

[<EntryPoint>]
let main argv =
    Console.WriteLine(SumOf(Console.ReadLine()))
    0
