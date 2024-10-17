let zeck n =
  let rec enc x s = function
    | h :: t when h <= x -> enc (x - h) (s ^ "1") t
    | _ :: t -> enc x (s ^ "0") t
    | _ -> s
  and fib b a l =
    if b > n
    then enc (n - a) "1" l
    else fib (b + a) b (a :: l)
  in
  if n = 0 then "0" else fib 2 1 []

let () =
  for i = 0 to 20 do Printf.printf "%3u:%8s\n" i (zeck i) done
