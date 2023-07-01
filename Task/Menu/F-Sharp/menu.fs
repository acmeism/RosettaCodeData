open System

let rec menuChoice (options : string list) prompt =
    if options = [] then ""
    else
        for i = 0 to options.Length - 1 do
            printfn "%d. %s" (i + 1) options.[i]

        printf "%s" prompt
        let input = Int32.TryParse(Console.ReadLine())

        match input with
        | true, x when 1 <= x && x <= options.Length -> options.[x - 1]
        | _, _ -> menuChoice options prompt

[<EntryPoint>]
let main _ =
    let menuOptions = ["fee fie"; "huff and puff"; "mirror mirror"; "tick tock"]
    let choice = menuChoice menuOptions "Choose one: "
    printfn "You chose: %s" choice

    0
