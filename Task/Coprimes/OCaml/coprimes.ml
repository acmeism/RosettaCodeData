let rec is_coprime a = function
  | 0 -> a = 1
  | b -> is_coprime b (a mod b)

let () =
  let p (a, b) =
    Printf.printf "%u and %u are%s coprime\n" a b (if is_coprime a b then "" else " not")
  in
  List.iter p [21, 15; 17, 23; 36, 12; 18, 29; 60, 15]
