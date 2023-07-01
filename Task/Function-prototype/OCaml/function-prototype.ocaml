(* Usually prototype declarations are put in an interface file,
   a file with .mli filename extension *)

(* A prototype declaration for a function that does not require arguments *)
val no_arg : unit -> unit

(* A prototype declaration for a function that requires two arguments *)
val two_args : int -> int -> unit

(* A prototype declaration for a function that utilizes optional arguments *)
val opt_arg : ?param:int -> unit -> unit
(* in this case we add a unit parameter in order to omit the argument,
   because ocaml supports partial application *)

(* A prototype declaration for a function that utilizes named parameters *)
val named_arg : param1:int -> param2:int -> unit

(* An explanation and example of any special forms of prototyping not covered by the above *)

(* A prototype declaration for a function that requires a function argument *)
val fun_arg : (int -> int) -> unit

(* A prototype declaration for a function with polymorphic argument *)
val poly_arg : 'a -> unit
