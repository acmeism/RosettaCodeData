open System

let ask_for_input s =
    printf "%s (End with Return): " s
    Console.ReadLine()

[<EntryPoint>]
let main argv =
    ask_for_input "Input a string" |> ignore
    ask_for_input "Enter the number 75000" |> ignore
    0
