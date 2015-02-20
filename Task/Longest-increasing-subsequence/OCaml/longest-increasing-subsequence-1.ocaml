let longest l = List.fold_left (fun acc x -> if List.length acc < List.length x
                                  then x
                                  else acc) [] l

let subsequences d l =
  let rec check_subsequences acc = function
    | x::s -> check_subsequences (if (List.hd (List.rev x)) < d
                                  then x::acc
                                  else acc) s
    | [] -> acc
  in check_subsequences [] l

let lis d =
  let rec lis' l = function
    | x::s -> lis' ((longest (subsequences x l)@[x])::l) s
    | [] -> longest l
  in lis' [] d

let _ =
  let sequences = [[3; 2; 6; 4; 5; 1]; [0; 8; 4; 12; 2; 10; 6; 14; 1; 9; 5; 13; 3; 11; 7; 15]]
  in
  List.map (fun x -> print_endline (String.concat " " (List.map string_of_int
                                                         (lis x)))) sequences
