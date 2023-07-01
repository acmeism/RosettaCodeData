open System.Text.RegularExpressions

// simplify regex matching with an active pattern
let (|Regexp|_|) pattern txt =
    match Regex.Match(txt, pattern) with
    | m when m.Success -> [for g in m.Groups -> g.Value] |> List.tail |> Some
    | _                -> None

// Parse and expand a single range description.
// string -> int list
let parseRange r =
  match r with
  | Regexp @"^(-?\d+)-(-?\d+)$" [first; last] -> [int first..int last]
  | Regexp @"^(-?\d+)$"         [single]      -> [int single]
  | _ -> failwithf "illegal range format: %s" r


let expand (desc:string) =
  desc.Split(',')
  |> List.ofArray
  |> List.collect parseRange

printfn "%A" (expand "-6,-3--1,3-5,7-11,14,15,17-20")
