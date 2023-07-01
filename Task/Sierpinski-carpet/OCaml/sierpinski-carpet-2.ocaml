let nextCarpet carpet =
  List.map (fun x -> x ^ x ^ x) carpet @
  List.map (fun x -> x ^ String.make (String.length x) ' ' ^ x) carpet @
  List.map (fun x -> x ^ x ^ x) carpet

let rec sierpinskiCarpet n =
  let rec aux n carpet =
    if n = 0 then carpet
             else aux (n-1) (nextCarpet carpet)
  in
  aux n ["#"]

let () =
  List.iter print_endline (sierpinskiCarpet 3)
