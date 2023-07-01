open System

let stripControl (arg:string) =
    String(Array.filter (fun x -> not (Char.IsControl(x))) (arg.ToCharArray()))
//end stripControl

let stripExtended (arg:string) =
    let numArr = Array.map (fun (x:char) -> Convert.ToUInt16(x)) (arg.ToCharArray()) in
    String([|for num in numArr do if num >= 32us && num <= 126us then yield Convert.ToChar(num) |])
//end stripExtended

[<EntryPoint>]
let main args =
    let test = "string of ☺☻♥♦⌂, may include control characters and other ilk.♫☼§►↔◄"
    printfn "Original: %s" test
    printfn "Stripped of controls: %s" (stripControl test)
    printfn "Stripped of extended: %s" (stripExtended test)
    0//main must return integer, much like in C/C++
