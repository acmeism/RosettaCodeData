let disjoint_sort cmp values indices =
  let indices = List.sort compare indices in
  let rec aux acc j = function
    | (i::iq), (v::vq) when i = j ->
        aux (v::acc) (succ j) (iq, vq)
    | [], _ -> acc
    | il, (_::vq) ->
        aux acc (succ j) (il, vq)
    | _, [] ->
        invalid_arg "index out of bounds"
  in
  let temp = aux [] 0 (indices, values) in
  let temp = List.sort cmp temp in
  let rec aux acc j = function
    | (i::iq), (_::vq), (r::rq) when i = j ->
        aux (r::acc) (succ j) (iq, vq, rq)
    | [], vl, _ ->
        List.rev_append acc vl
    | il, (v::vq), rl ->
        aux (v::acc) (succ j) (il, vq, rl)
    | (_::_, [], _) ->
        assert false
  in
  aux [] 0 (indices, values, temp)

let () =
  let values = [ 7; 6; 5; 4; 3; 2; 1; 0 ]
  and indices = [ 6; 1; 7 ] in
  let res = disjoint_sort compare values indices in
  List.iter (Printf.printf " %d") res;
  print_newline()
