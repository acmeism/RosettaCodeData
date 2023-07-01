open System
open System.Text.RegularExpressions

[<EntryPoint>]
let main argv =
    let str = "I am a string"
    if Regex("string$").IsMatch(str) then Console.WriteLine("Ends with string.")

    let rstr = Regex(" a ").Replace(str, " another ")
    Console.WriteLine(rstr)
    0
