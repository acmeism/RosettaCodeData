open System
open System.IO

let truncateFile path length =
    if not (File.Exists(path)) then failwith ("File not found: " + path)
    use fileStream = new FileStream(path, FileMode.Open, FileAccess.Write)
    if (fileStream.Length < length) then failwith "The specified length is greater than the current file length."
    fileStream.SetLength(length)

[<EntryPoint>]
let main args =
    truncateFile args.[0] (Int64.Parse(args.[1]))
    0
