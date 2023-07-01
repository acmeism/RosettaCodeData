let rec in_carpet x y =
  if x = 0 || y = 0 then true
  else if x mod 3 = 1 && y mod 3 = 1 then false
  else in_carpet (x / 3) (y / 3)

(* I define my own operator for integer exponentiation *)
let rec (^:) a b =
  if b = 0 then 1
  else if b mod 2 = 0 then let x = a ^: (b / 2) in x * x
  else a * (a ^: (b - 1))

let carpet n =
  for i = 0 to (3 ^: n) - 1 do
    for j = 0 to (3 ^: n) - 1 do
      print_char (if in_carpet i j then '*' else ' ')
    done;
    print_newline ()
  done
