open List;;

let analyze cmp l  =
  let rec analyze' l prevs =
    match l with
    [] -> true
    | [s] -> cmp prevs s
    | s::rest -> (cmp prevs s) && (analyze' rest s)
  in analyze' (List.tl l) (List.hd l)
;;

let isEqual     = analyze (=) ;;
let isAscending = analyze (<) ;;

let test sample =
   List.iter print_endline sample;
   if (isEqual sample)
       then (print_endline "elements are identical")
       else (print_endline "elements are not identical");
   if (isAscending sample)
	     then print_endline "elements are in ascending order"
         else print_endline "elements are not in ascending order";;


let lasc =   ["AA";"BB";"CC";"EE"];;
let leq =    ["AA";"AA";"AA";"AA"];;
let lnoasc = ["AA";"BB";"EE";"CC"];;

List.iter test [lasc;leq;lnoasc];;
