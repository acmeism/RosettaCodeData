open System
open System.IO

[<EntryPoint>]
let main args =
    let n = Int32.Parse(args.[1]) - 1
    use r = new StreamReader(args.[0])
    let lines = Seq.unfold (
                    fun (reader : StreamReader) ->
                    if (reader.EndOfStream) then None
                    else Some(reader.ReadLine(), reader)) r
    let line = Seq.nth n lines  // Seq.nth throws an ArgumentException,
                                // if not not enough lines available
    Console.WriteLine(line)
    0
