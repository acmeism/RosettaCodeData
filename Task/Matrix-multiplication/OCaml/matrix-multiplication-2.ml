(* equivalent to (apply map ...) *)
let rec mapn f lists =
  assert (lists <> []);
  if List.mem [] lists then
    []
  else
    f (List.map List.hd lists) :: mapn f (List.map List.tl lists)

let matrix_multiply m1 m2 =
  List.map
    (fun row ->
      mapn
       (fun column ->
         List.fold_left (+) 0
          (List.map2 ( * ) row column))
       m2)
    m1
