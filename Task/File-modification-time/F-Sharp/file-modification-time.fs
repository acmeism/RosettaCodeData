open System
open System.IO

[<EntryPoint>]
let main args =
    Console.WriteLine(File.GetLastWriteTime(args.[0]))
    File.SetLastWriteTime(args.[0], DateTime.Now)
    0
