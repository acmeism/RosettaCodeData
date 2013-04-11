let list_of_string str =
  let result = ref [] in
  String.iter (fun x -> result := x :: !result)
              str;
  List.rev !result

let string_of_list lst =
  let result = String.create (List.length lst) in
  ignore (List.fold_left (fun i x -> result.[i] <- x; i+1) 0 lst);
  result
