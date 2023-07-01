module SudokuBacktrack

//Helpers
let tuple2 a b = a,b
let flip  f a b = f b a
let (>>=) f g = Option.bind g f

/// "A1" to "I9" squares as key in values dictionary
let key a b = $"{a}{b}"

/// Cross product of elements in ax and elements in bx
let cross ax bx = [| for a in ax do for b in bx do key a b |]

// constants
let valid   = "1234567890.,"
let rows    = "ABCDEFGHI"
let cols    = "123456789"
let squares = cross rows cols

// List of all row, cols and boxes:  aka units
let unitList =
    [for c in cols do cross rows (string c) ]@ // row units
    [for r in rows do cross (string r) cols ]@ // col units
    [for rs in ["ABC";"DEF";"GHI"] do for cs in ["123";"456";"789"] do cross rs cs ] // box units

/// Dictionary of units for each square
let units =
    [for s in squares do s, [| for u in unitList do if u |> Array.contains s then u |] ] |> Map.ofSeq

/// Dictionary of all peer squares in the relevant units wrt square in question
let peers =
    [for s in squares do units[s] |> Array.concat |> Array.distinct |> Array.except [s] |> tuple2 s] |> Map.ofSeq

/// Should parse grid in many input formats or return None
let parseGrid grid =
    let ints = [for c in grid do if valid |> Seq.contains c then if ",." |> Seq.contains c then 0 else (c |> string |> int)]
    if Seq.length ints = 81 then ints |> Seq.zip squares |> Map.ofSeq |> Some else None

/// Outputs single line puzzle with 0 as empty squares
let asString  =  function
    | Some values -> values |> Map.toSeq |> Seq.map (snd>>string) |> String.concat ""
    | _ ->  "No solution or Parse Failure"

/// Outputs puzzle in 2D format with 0 as empty squares
let prettyPrint = function
    | Some (values:Map<_,_>) ->
        [for r in rows do [for c in cols do (values[key r c] |> string) ] |> String.concat " " ] |> String.concat "\n"
    | _ ->  "No solution or Parse Failure"

/// Is digit allowed in the square in question? !!! hot path !!!!
/// Array/Array2D no faster and they need explicit copy since not immutable
let constraints (values:Map<_,_>) s d = peers[s] |> Seq.map (fun p -> values[p]) |> Seq.exists ((=) d) |> not

/// Move to next square or None if out of bounds
let next s = squares |> Array.tryFindIndex ((=)s) |> function Some i when i + 1 < 81 -> Some squares[i + 1] | _ -> None

/// Backtrack recursively and immutably from index
let rec backtracker (values:Map<_,_>) = function
    | None -> Some values // solved!
    | Some s when values[s] > 0 -> backtracker values (next s)  // square not empty
    | Some s ->
        let rec tracker  = function
            | [] -> None
            | d::dx ->
                values
                |> Map.change s (Option.map (fun _ -> d))
                |> flip backtracker (next s)
                |> function
                | None ->  tracker dx
                | success -> success
        [for d in 1..9 do if constraints values s d then d] |> tracker

/// solve sudoku using simple backtracking
let solve grid = grid |> parseGrid >>= flip backtracker (Some "A1")
