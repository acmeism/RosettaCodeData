type 'a variadic =
  | Z : unit variadic
  | U : 'a variadic -> (unit -> 'a) variadic
  | S : 'a variadic -> (string -> 'a) variadic
  | I : 'a variadic -> (int -> 'a) variadic
  | F : 'a variadic -> (float -> 'a) variadic
  (* Printing of a general type, takes pretty printer as argument *)
  | G : 'a variadic -> (('t -> unit) -> 't -> 'a) variadic
  | L : 'a variadic -> (('t -> unit) -> 't list -> 'a) variadic

let rec print : type a. a variadic -> a = function
  | Z -> ()
  | U v -> fun () -> Format.printf "()\n"; print v
  | S v -> fun x -> Format.printf "%s\n" x; print v
  | I v -> fun x -> Format.printf "%d\n" x; print v
  | F v -> fun x -> Format.printf "%f\n" x; print v
  | G v -> fun pp x -> pp x; print v
  | L v -> fun pp x -> List.iter pp x; print v

let () =
  print (S (I (S Z))) "I am " 5 "Years old";
  print (S (I (S (L (S Z))))) "I have " 3 " siblings aged " (print (I Z)) [1;3;7]
