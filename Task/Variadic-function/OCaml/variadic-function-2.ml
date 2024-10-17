type 'a variadic =
  | Z : unit variadic
  | S : 'a variadic -> (string -> 'a) variadic

let rec print : type a. a variadic -> a = function
  | Z -> ()
  | S v -> fun x -> Format.printf "%s\n" x; print v

let () =
  print Z;                              (* no arguments *)
  print (S Z) "hello";                  (* one argument *)
  print (S (S (S Z))) "how" "are" "you" (* three arguments *)
