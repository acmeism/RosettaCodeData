open System.IO

[<EntryPoint>]
let main args =
    File.Move("input.txt","output.txt")
    File.Move(@"\input.txt",@"\output.txt")
    Directory.Move("docs","mydocs")
    Directory.Move(@"\docs",@"\mydocs")
    0
