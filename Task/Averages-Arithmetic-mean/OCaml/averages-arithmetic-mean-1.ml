let mean_floats = function
  | [] -> 0.
  | xs -> List.fold_left (+.) 0. xs /. float_of_int (List.length xs)

let mean_ints xs = mean_floats (List.map float_of_int xs)
