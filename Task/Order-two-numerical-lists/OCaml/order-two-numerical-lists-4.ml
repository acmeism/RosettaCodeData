(* copy-paste the code of ordered_lists here *)

let make_num_list p n =
  let rec aux acc =
    if Random.int p = 0 then acc
    else aux (Random.int n :: acc)
  in
  aux []

let print_num_list lst =
  List.iter (Printf.printf " %d") lst;
  print_newline()

let () =
  Random.self_init();
  let lst1 = make_num_list 8 5 in
  let lst2 = make_num_list 8 5 in
  print_num_list lst1;
  print_num_list lst2;
  Printf.printf "ordered: %B\n" (ordered_lists (lst1, lst2))
