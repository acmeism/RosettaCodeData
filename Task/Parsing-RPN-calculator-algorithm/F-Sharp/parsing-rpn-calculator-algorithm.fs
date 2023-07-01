let reduce op = function
  | b::a::r -> (op a b)::r
  | _ -> failwith "invalid expression"

let interprete s = function
  | "+" -> "add",    reduce ( + ) s
  | "-" -> "subtr",  reduce ( - ) s
  | "*" -> "mult",   reduce ( * ) s
  | "/" -> "divide", reduce ( / ) s
  | "^" -> "exp",    reduce ( ** ) s
  | str -> "push", (System.Double.Parse str) :: s

let interp_and_show s inp =
  let op,s'' = interprete s inp
  printf "%5s%8s " inp op
  List.iter (printf " %-6.3F") (List.rev s'')
  printf "\n";
  s''

let eval str =
  printfn "Token  Action  Stack";
  let ss = str.ToString().Split() |> Array.toList
  List.fold interp_and_show [] ss
