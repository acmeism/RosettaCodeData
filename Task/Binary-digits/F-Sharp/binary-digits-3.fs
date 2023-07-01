open System
open System.IO

// define a callback function for %a
let bin (tw: TextWriter) value =
    tw.Write("{0}", Convert.ToString(int64 value, 2))

// use it with printfn with %a
[5; 50; 9000]
|> List.iter (printfn "binary: %a" bin)
