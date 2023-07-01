// https://norvig.com/sudoku.html
// using array O(1) lookup & mutable  instead of map O(logn) immutable - now 6 times faster
module SudokuCPSArray
open System

/// from 11 to 99 as squares key maps to 0 to 80 in arrays
let key a b = (9*a + b) - 10

/// Keys generator
let cross ax bx = [| for a in ax do for b in bx do key a b |]

let digits  = [|1..9|]
let rows    = digits
let cols    = digits
let empty   = "0,."
let valid   = "123456789"+empty
let boxi    = [for b in 1..3..9 -> [|b..b+2|]]
let squares = cross rows cols

/// List of all row, cols and boxes:  aka units
let unitlist =
    [for c in cols -> cross rows [|c|] ]@
    [for r in rows -> cross [|r|] cols ]@
    [for rs in boxi do for cs in boxi do cross rs cs ]

/// Dictionary of units for each square
let units =
    [|for s in squares do [| for u in unitlist do if u |> Array.contains s then u |] |]

/// Dictionary of all peer squares in the relevant units wrt square in question
let peers =
    [| for s in squares do units[s] |> Array.concat |> Array.distinct |> Array.except [s] |]

/// folds folder returning Some on completion or returns None if not
let rec all folder state source =
    match state, source with
    | None, _ -> None
    | Some st, [] -> Some st
    | Some st , hd::rest -> folder st hd |> (fun st1 -> all folder st1 rest)

/// Assign digit d to values[s] and propagate (via eliminate)
/// Return Some values, except None if a contradiction is detected.
let rec assign (values:int[][]) (s) d =
    values[s]
    |> Array.filter ((<>)d)
    |> List.ofArray |> all (fun vx d1 -> eliminate vx s d1) (Some values)

/// Eliminate digit d from values[s] and propagate when values[s] size is 1.
/// Return Some values, except return None if a contradiction is detected.
and eliminate (values:int[][]) s d =
    let peerElim (values1:int[][]) = // If a square s is reduced to one value d, then *eliminate* d from the peers.
        match Seq.length values1[s] with
        | 0 -> None // contradiction - removed last value
        | 1 -> peers[s] |> List.ofArray |> all (fun vx1 s1 ->  eliminate vx1 s1 (values1[s] |> Seq.head) ) (Some values1)
        | _ -> Some values1

    let unitsElim values1 = // If a unit u is reduced to only one place for a value d, then *assign* it there.
        units[s]
        |> List.ofArray
        |> all (fun (vx1:int[][]) u ->
           let sx = [for s in u do if vx1[s] |> Seq.contains d then s]
           match Seq.length sx with
           | 0 -> None
           | 1 -> assign vx1 (Seq.head sx) d
           | _ -> Some vx1) (Some values1)

    match values[s] |> Seq.contains d with
    | false ->  Some values // Already eliminated, nothing to do
    | true ->
        values[s] <- values[s]|> Array.filter ((<>)d)
        values
        |> peerElim
        |> Option.bind unitsElim

/// Convert grid into a Map of {square: char} with "0","."or"," for empties.
let parseGrid grid =
    let cells = [for c in grid do if valid |> Seq.contains c then if empty |> Seq.contains c then 0 else ((string>>int)c)]
    if Seq.length cells = 81 then cells |> Seq.zip squares |> Map.ofSeq |> Some  else None

/// Convert grid to a Map of constraint propagated possible values, or return None if a contradiction is detected.
let applyCPS (parsedGrid:Map<_,_>) =
    let values = [| for s in squares do digits |]
    parsedGrid
    |> Seq.filter (fun (KeyValue(_,d)) -> digits |> Seq.contains d)
    |> List.ofSeq
    |> all (fun vx (KeyValue(s,d)) -> assign vx s d) (Some values)

/// Calculate string centre for each square - which can contain more than 1 digit when debugging
let centre s width =
    let n = width - (Seq.length s)
    if n <= 0 then s
    else
        let half = n/2 + (if (n%2>0 && width%2>0) then 1 else 0)
        sprintf "%s%s%s" (String(' ',half)) s (String(' ', n - half))

/// Display these values as a 2-D grid. Used for debugging
let prettyPrint (values:int[][]) =
    let asString = Seq.map string >> String.concat ""
    let width = 1 + ([for s in squares do Seq.length values[s]] |> List.max)
    let line = sprintf "%s\n" ((String('-',width*3) |> Seq.replicate 3) |> String.concat "+")
    [for r in rows do
        for c in cols do
            sprintf "%s%s" (centre (asString values[key r c]) width) (if List.contains c [3;6] then "|" else "")
        sprintf "\n%s"(if List.contains r [3;6] then line else "") ]
    |> String.concat ""

/// Outputs single line puzzle with 0 as empty squares
let asString values = values |> Map.toSeq |> Seq.map (snd>>string) |> String.concat ""

let copy values = values |> Array.map Array.copy

/// Using depth-first search and propagation, try all possible values.
let rec search (values:int[][])=
    [for s in squares do if Seq.length values[s] > 1 then Seq.length values[s] ,s]
    |> function
    | [] -> Some values // Solved!
    | list -> // tryPick ~ Norvig's `some`
        list |> List.minBy fst
        |> fun (_,s) -> values[s] |> Seq.tryPick (fun d -> assign (copy values) s d |> (Option.bind search))

let run n g f = parseGrid >> function None -> n | Some m -> f m |> g
let solver = run "Parse Error" (Option.fold (fun _ t -> t |> prettyPrint) "No Solution")
let solveNoSearch: string -> string = solver applyCPS
let solveWithSearch: string -> string = solver (applyCPS >> (Option.bind search))
let solveWithSearchToMapOnly:string -> int[][] option = run None id (applyCPS >> (Option.bind search))
