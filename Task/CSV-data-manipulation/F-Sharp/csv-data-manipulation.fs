open System.IO

[<EntryPoint>]
let main _ =
    let input = File.ReadAllLines "test_in.csv"
    let output =
        input
        |> Array.mapi (fun i line ->
            if i = 0 then line + ",SUM"
            else
                let sum = Array.sumBy int (line.Split(','))
                sprintf "%s,%i" line sum)
    File.WriteAllLines ("test_out.csv", output)
    0
