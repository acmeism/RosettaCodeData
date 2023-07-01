let unique li =
  let rec aux acc = function
  | [] -> (List.rev acc)
  | x::xs ->
      if List.mem x acc
      then aux acc xs
      else aux (x::acc) xs
  in
  aux [] li
