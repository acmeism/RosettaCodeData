open System

[<EntryPoint>]
let main argv =
    // columns and rows are 0-based, so the input has to be decremented:
    let maxRow =
        match UInt32.TryParse(argv.[0]) with
        | (true, v) when v > 0u -> int (v - 1u)
        | (_, _) -> failwith "not a positive integer"

    let len (n: int) = int (Math.Floor(Math.Log10(float n)))
    let col0 row = row * (row + 1) / 2 + 1
    let col0maxRow = col0 maxRow
    for row in [0 .. maxRow] do
        for col in [0 .. row] do
            let value = (col0 row) + col
            let pad = String(' ', (len (col0maxRow + col) - len (value) + 1))
            printf "%s%d" pad value
        printfn ""
    0
