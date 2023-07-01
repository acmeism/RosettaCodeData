open System

// define the function
let printBin (i: int) =
    Convert.ToString (i, 2)
    |> printfn "%s"

// use the function
[5; 50; 9000]
|> List.iter printBin
