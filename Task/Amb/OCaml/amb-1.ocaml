let set_1 = ["the"; "that"; "a"]
let set_2 = ["frog"; "elephant"; "thing"]
let set_3 = ["walked"; "treaded"; "grows"]
let set_4 = ["slowly"; "quickly"]

let combs ll =
  let rec aux acc = function
  | [] -> (List.map List.rev acc)
  | hd::tl ->
      let acc =
        List.fold_left
          (fun _ac l ->
            List.fold_left (fun _ac v -> (v::l)::_ac) _ac hd
          ) [] acc
      in
      aux acc tl
  in
  aux [[]] ll

let last s = s.[pred(String.length s)]
let joined a b = (last a = b.[0])

let rec test = function
  | a::b::tl -> (joined a b) && (test (b::tl))
  | _ -> true

let print_set set =
  List.iter (Printf.printf " %s") set;
  print_newline();
;;

let () =
  let sets = combs [set_1; set_2; set_3; set_4] in
  let sets = List.filter test sets in
  List.iter print_set sets;
;;
