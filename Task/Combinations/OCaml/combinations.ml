let combinations m n =
  let rec c = function
    | (0,_) -> [[]]
    | (_,0) -> []
    | (p,q) -> List.append
               (List.map (List.cons (n-q)) (c (p-1, q-1)))
               (c (p , q-1))
  in c (m , n)


let () =
  let rec print_list = function
    | [] -> print_newline ()
    | hd :: tl -> print_int hd ; print_string " "; print_list tl
  in List.iter print_list (combinations 3 5)
