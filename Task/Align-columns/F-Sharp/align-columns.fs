open System
open System.IO

let tableFromPath path =
    let lines =
        [ for line in File.ReadAllLines(path) -> (line.TrimEnd('$').Split('$')) ]
    let width = List.fold (fun max (line : string[]) -> if max < line.Length then line.Length else max) 0 lines
    List.map (fun (a : string[]) -> (List.init width (fun i -> if i < a.Length then a.[i] else ""))) lines

let rec trans m =
    match m with
    | []::_ -> []
    | _ -> (List.map List.head m) :: trans (List.map List.tail m)

let colWidth table =
    List.map (fun col -> List.max (List.map String.length col)) (trans table)

let left = (fun (s : string) n -> s.PadRight(n))
let right = (fun (s : string) n -> s.PadLeft(n))
let center = (fun (s : string) n -> s.PadLeft((n + s.Length) / 2).PadRight(n))

[<EntryPoint>]
let main argv =
    let table = tableFromPath argv.[0]
    let width = Array.ofList (colWidth table)
    let format table align =
        List.map (fun (row : string list) -> List.mapi (fun i s -> sprintf "%s" (align s width.[i])) row) table
        |> List.iter (fun row -> printfn "%s" (String.Join(" ", Array.ofList row)))

    for align in [ left; right; center ] do
        format table align
        printfn "%s" (new String('-', (Array.sum width) + width.Length - 1))
    0
