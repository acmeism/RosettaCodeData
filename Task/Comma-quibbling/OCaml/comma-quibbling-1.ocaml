open Printf

let quibble list =
  let rec aux = function
    | a :: b :: c :: d :: rest -> a ^ ", " ^ aux (b :: c :: d :: rest)
    | [a; b; c] -> sprintf "%s, %s and %s}" a b c
    | [a; b] -> sprintf "%s and %s}" a b
    | [a] -> sprintf "%s}" a
    | [] -> "}" in
  "{" ^ aux list

let test () =
  [[];
   ["ABC"];
   ["ABC"; "DEF"];
   ["ABC"; "DEF"; "G"; "H"]]
  |> List.iter (fun list -> print_endline (quibble list))
