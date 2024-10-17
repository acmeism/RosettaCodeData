(* interface *)
module type RATIO =
   sig
     type t
     (* construct *)
     val frac : int -> int -> t
     val from_int : int -> t

     (* integer test *)
     val is_int : t -> bool

     (* output *)
     val to_string : t -> string

     (* arithmetic *)
     val cmp : t -> t -> int
     val ( +/ ) : t -> t -> t
     val ( -/ ) : t -> t -> t
     val ( */ ) : t -> t -> t
     val ( // ) : t -> t -> t
   end
