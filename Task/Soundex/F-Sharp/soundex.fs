module Soundex

let soundex (s : string) =
    let code c =
        match c with
        | 'B' | 'F' | 'P' | 'V' -> Some('1')
        | 'C' | 'G' | 'J' | 'K' | 'Q' | 'S' | 'X' | 'Z' -> Some('2')
        | 'D' | 'T' -> Some('3')
        | 'L' -> Some('4')
        | 'M' | 'N' -> Some('5')
        | 'R' -> Some('6')
        | _ -> None

    let rec p l =
        match l with
        | [] -> []
        | x :: y :: tail when (code x) = (code y) -> (p (y :: tail))
        | x :: 'W' :: y :: tail when (code x) = (code y) -> (p (y :: tail))
        | x :: 'H' :: y :: tail when (code x) = (code y) -> (p (y :: tail))
        | x :: tail -> (code x) :: (p tail)

    let chars =
        match (p (s.ToUpper() |> List.ofSeq)) with
        | [] -> ""
        | head :: tail -> new string((s.[0] :: (tail |> List.filter (fun x -> x.IsSome) |> List.map (fun x -> x.Value))) |> List.toArray)
    chars.PadRight(4, '0').Substring(0, 4)

let test (input, se) =
    printfn "%12s\t%s\t%s" input se (soundex input)

let testCases = [|
    ("Ashcraft", "A261"); ("Ashcroft", "A261"); ("Burroughs", "B620"); ("Burrows", "B620");
    ("Ekzampul", "E251"); ("Example", "E251"); ("Ellery", "E460"); ("Euler", "E460");
    ("Ghosh", "G200"); ("Gauss", "G200"); ("Gutierrez", "G362"); ("Heilbronn", "H416");
    ("Hilbert", "H416"); ("Jackson", "J250"); ("Kant", "K530"); ("Knuth", "K530");
    ("Lee", "L000"); ("Lukasiewicz", "L222"); ("Lissajous", "L222"); ("Ladd", "L300");
    ("Lloyd", "L300"); ("Moses", "M220"); ("O'Hara", "O600"); ("Pfister", "P236");
    ("Rubin", "R150"); ("Robert", "R163"); ("Rupert", "R163"); ("Soundex", "S532");
    ("Sownteks", "S532"); ("Tymczak", "T522"); ("VanDeusen", "V532"); ("Washington", "W252");
    ("Wheaton", "W350");
    |]

[<EntryPoint>]
let main args =
    testCases |> Array.sortBy (fun (_, x) -> x) |> Array.iter test
    System.Console.ReadLine() |> ignore

    0
