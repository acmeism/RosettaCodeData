open System.IO

let copyFile fromTextFileName toTextFileName =
    let inputContent = File.ReadAllText fromTextFileName
    inputContent |> fun text -> File.WriteAllText(toTextFileName, text)

[<EntryPoint>]
let main argv =
    copyFile "input.txt" "output.txt"
    0
