let disjoint_sort cmp values indices =
  let temp = Array.map (Array.get values) indices in
  Array.sort cmp temp;
  Array.sort compare indices;
  Array.iteri (fun i j -> values.(j) <- temp.(i)) indices

let () =
  let values = [| 7; 6; 5; 4; 3; 2; 1; 0 |]
  and indices = [| 6; 1; 7 |] in
  disjoint_sort compare values indices;
  Array.iter (Printf.printf " %d") values;
  print_newline()
