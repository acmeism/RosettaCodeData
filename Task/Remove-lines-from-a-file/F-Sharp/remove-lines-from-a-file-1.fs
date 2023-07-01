open System
open System.IO

let cutOut (arr : 'a[]) from n =  // confine syntax highlighting confusion'
    let slicer = fun i -> if i < from || (from + n) <= i then Some(arr.[i-1]) else None
    ((Array.choose slicer [| 1 .. arr.Length |]), from + n - arr.Length > 1)

[<EntryPoint>]
let main argv =
    let nums = Array.choose (System.Int32.TryParse >> function | true, v -> Some v | false, _ -> None) argv.[1..2]
    let lines = File.ReadAllLines(argv.[0])
    let (sliced, tooShort) = cutOut lines nums.[0] nums.[1]
    if tooShort then Console.Error.WriteLine "Not enough lines"
    File.WriteAllLines(argv.[0], sliced)
    0
