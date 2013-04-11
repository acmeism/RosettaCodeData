type trit = True | False | Maybe

let to_bin = function True -> [true] | False -> [false] | Maybe -> [true;false]

let eval f x =
   List.fold_left (fun l c -> List.fold_left (fun m d -> ((d c) :: m)) l f) [] x

let rec from_bin =
   function [true] -> True | [false] -> False
   | h :: t -> (match (h, from_bin t) with
      (true,True) -> True | (false,False) -> False | _ -> Maybe)
   | _ -> Maybe

let to_ternary1 uop = fun x -> from_bin (eval [uop] (to_bin x))
let to_ternary2 bop = fun x y -> from_bin (eval (eval [bop] (to_bin x)) (to_bin y))

let t_not   = to_ternary1 (not)
let t_and   = to_ternary2 (&&)
let t_or    = to_ternary2 (||)
let t_equiv = to_ternary2 (=)
let t_imply = to_ternary2 (fun p q -> (not p) || q)

let str = function True -> "True " | False -> "False" | Maybe -> "Maybe"
let iterv f = List.iter f [True; False; Maybe]

let table1 s u =
   print_endline ("\n"^s^":");
   iterv (fun v -> print_endline ("  "^(str v)^" -> "^(str (u v))));;

let table2 s b =
   print_endline ("\n"^s^":");
   iterv (fun u ->
      iterv (fun v ->
         print_endline ("  "^(str u)^" "^(str v)^" -> "^(str (b u v)))));;

table1 "not" t_not;;
table2 "and" t_and;;
table2 "or" t_or;;
table2 "equiv" t_equiv;;
table2 "implies" t_imply;;
