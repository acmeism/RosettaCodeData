open System

[<EntryPoint>]
let main args =
    let s = "hello"
    Console.Write(s)
    Console.WriteLine(" literal")
    let s2 = s + " literal"
    Console.WriteLine(s2)
    0
