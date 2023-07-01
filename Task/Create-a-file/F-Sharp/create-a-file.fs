open System.IO

[<EntryPoint>]
let main argv =
    let fileName = "output.txt"
    let dirName = "docs"
    for path in ["."; "/"] do
        ignore (File.Create(Path.Combine(path, fileName)))
        ignore (Directory.CreateDirectory(Path.Combine(path, dirName)))
    0
