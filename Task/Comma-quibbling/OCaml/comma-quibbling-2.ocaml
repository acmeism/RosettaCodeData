open Core

let quibble = function
  | [| |] -> "{}"
  | [| a |] -> sprintf "{%s}" a
  | array ->
    let last, rest = Array.last array, Array.slice array 0 (-1) in
    sprintf "{%s and %s}" (String.concat_array ~sep:", " rest) last

let test () =
  [[||];
   [|"ABC"|];
   [|"ABC"; "DEF"|];
   [|"ABC"; "DEF"; "G"; "H"|]]
  |> List.iter ~f:(fun list -> print_endline (quibble list))
