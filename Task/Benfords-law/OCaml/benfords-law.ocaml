open Num

let fib =
  let rec fib_aux f0 f1 = function
    | 0 -> f0
    | 1 -> f1
    | n -> fib_aux f1 (f1 +/ f0) (n - 1)
  in
  fib_aux (num_of_int 0) (num_of_int 1) ;;

let create_fibo_string = function n -> string_of_num (fib n) ;;
let rec range i j = if i > j then [] else i :: (range (i + 1) j)

let n_max = 1000 ;;

let numbers = range 1 n_max in
  let get_first_digit = function s -> Char.escaped (String.get s 0) in
    let first_digits = List.map get_first_digit (List.map create_fibo_string numbers) in
  let data = Array.create 9 0 in
    let fill_data vec = function n -> vec.(n - 1) <- vec.(n - 1) + 1 in
    List.iter (fill_data data) (List.map int_of_string first_digits) ;
    Printf.printf "\nFrequency of the first digits in the Fibonacci sequence:\n" ;
    Array.iter (Printf.printf "%f ")
      (Array.map (fun x -> (float x) /. float (n_max)) data) ;

let xvalues = range 1 9 in
  let benfords_law = function x -> log10 (1.0 +. 1.0 /. float (x)) in
    Printf.printf "\nPrediction of Benford's law:\n " ;
    List.iter (Printf.printf "%f ") (List.map benfords_law xvalues) ;
    Printf.printf "\n" ;;
