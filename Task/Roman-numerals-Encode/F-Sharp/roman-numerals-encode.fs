let digit x y z = function
    1 -> x
  | 2 -> x + x
  | 3 -> x + x + x
  | 4 -> x + y
  | 5 -> y
  | 6 -> y + x
  | 7 -> y + x + x
  | 8 -> y + x + x + x
  | 9 -> x + z
  | _ -> failwith "invalid call to digit"

let rec to_roman acc = function
    | x when x >= 1000 -> to_roman (acc + "M") (x - 1000)
    | x when x >= 100 -> to_roman (acc + digit "C" "D" "M" (x / 100)) (x % 100)
    | x when x >= 10 -> to_roman (acc + digit "X" "L" "C" (x / 10)) (x % 10)
    | x when x > 0 -> acc + digit "I" "V" "X" x
    | 0 -> acc
    | _ -> failwith "invalid call to_roman (negative input)"

let roman n = to_roman "" n

[<EntryPoint>]
let main args =
    [1990; 2008; 1666]
    |> List.map (fun n -> roman n)
    |> List.iter (printfn "%s")
    0
