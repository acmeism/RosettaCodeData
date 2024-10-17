let rec print = function
  | [] -> ()
  | x :: xs -> print_endline x; print xs

(* Or better yet *)
let print = List.iter print_endline

let () =
  print [];
  print ["hello"; "world!"]
