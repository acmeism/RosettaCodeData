open System
open System.Text.RegularExpressions

let mutable Inp = Console.In

let Out c = printf "%c" c; (if c = '.' then Environment.Exit 0)

let In() = Inp.Read() |> Convert.ToChar

let (|WordCharacter|OtherCharacter|) c =
    if Regex.IsMatch(c.ToString(),"[a-zA-Z]") then
        WordCharacter
    else
        OtherCharacter

let rec forward () =
    let c = In()
    let rec backward () : char =
        let c = In()
        match c with
        | WordCharacter ->
            let s = backward() in Out c; s
        | OtherCharacter -> c
    Out c
    match c with
    | WordCharacter -> forward()
    | OtherCharacter -> backward()

[<EntryPoint>]
let main argv =
    if argv.Length > 0 then Inp <- new System.IO.StringReader(argv.[0])
    let rec loop () = forward() |> Out;  loop()
    loop()
    0
