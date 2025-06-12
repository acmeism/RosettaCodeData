let num_divisors (n : int) : int =
  if n = 0 || n = 1 then 1 else if n = 2 then 2 else
  List.init (n / 2) ((+) 1) (* O(n) *)
  |> List.filter (fun i -> n mod i = 0)
  |> List.length

let first_n_antiprimes (n : int) : int list =
  let rec loop = function
    | i, record, antis when List.length antis = n -> antis
    | i, record, antis -> let nd = num_divisors i in
      if nd > record then loop (i + 1, nd, i :: antis) else
      loop (i + 1, record, antis)
  in loop (2, 1, [1]) |> List.rev

let () = first_n_antiprimes 19
  |> List.map string_of_int
  |> String.concat ", "
  |> Printf.printf "[%s]\n"
