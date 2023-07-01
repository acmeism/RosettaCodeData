open Num

let fib =
  let rec fib_aux f0 f1 = function
    | 0 -> f0
    | 1 -> f1
    | n -> fib_aux f1 (f1 +/ f0) (n - 1)
  in
  fib_aux (num_of_int 0) (num_of_int 1)

(* support for negatives *)
let fib n =
      if n < 0 && n mod 2 = 0 then minus_num (fib (abs n))
      else fib (abs n)
;;
(* It can be called from the command line with an argument *)
(* Result is send to standart output *)
let n = int_of_string Sys.argv.(1) in
print_endline (string_of_num (fib n))
