(* Task : General_FizzBuzz *)

(*
	The FizzBuzz problem, but
	generalized to have any strings, at any steps,
	up to any number of iterations.
*)

let gen_fizz_buzz (n : int) (l : (int * string) list) : unit =
  let fold_f i (acc : bool) (k, s) =
    if i mod k = 0
    then (print_string s; true)
    else acc
  in
  let rec helper i =
    if i > n
    then ()
    else
      let any_printed = List.fold_left (fold_f i) false l in
      begin
        (if not any_printed
         then print_int i);
        print_newline ();
        helper (succ i)
      end
  in
  helper 1
;;

(*** Output ***)

gen_fizz_buzz 20 [(3, "Fizz"); (5, "Buzz"); (7, "Baxx")] ;;
