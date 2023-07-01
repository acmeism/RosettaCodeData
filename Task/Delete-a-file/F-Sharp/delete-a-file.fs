open System.IO

[<EntryPoint>]
let main argv =
    let fileName = "input.txt"
    let dirName = "docs"
    for path in ["."; "/"] do
        ignore (File.Delete(Path.Combine(path, fileName)))
        ignore (Directory.Delete(Path.Combine(path, dirName)))
    0
