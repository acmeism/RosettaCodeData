let is_prime n =
  let rec test x =
    let q = n / x in x > q || x * q <> n && n mod (x + 2) <> 0 && test (x + 6)
  in if n < 5 then n lor 1 = 3 else n land 1 <> 0 && n mod 3 <> 0 && test 5

let ascending_ints =
  let rec range10 m d = if d < 10 then m + d :: range10 m (succ d) else [] in
  let up n = range10 (n * 10) (succ (n mod 10)) in
  let rec next l = if l = [] then [] else l @ next (List.concat_map up l) in
  next [0]

let () =
  List.filter is_prime ascending_ints
  |> List.iter (Printf.printf " %u") |> print_newline
