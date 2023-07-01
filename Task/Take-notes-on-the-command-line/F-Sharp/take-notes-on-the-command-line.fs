open System;;
open System.IO;;

let file_path = "notes.txt";;

let show_notes () =
    try
        printfn "%s" <| File.ReadAllText(file_path)
    with
        _ -> printfn "Take some notes first!";;

let take_note (note : string) =
    let now = DateTime.Now.ToString() in
    let note = sprintf "%s\n\t%s" now note in
    use file_stream = File.AppendText file_path in (* 'use' closes file_stream automatically when control leaves the scope *)
        file_stream.WriteLine note;;

[<EntryPoint>]
let main args =
    match Array.length args with
        | 0 -> show_notes()
        | _ -> take_note <| String.concat " " args;
    0;;
