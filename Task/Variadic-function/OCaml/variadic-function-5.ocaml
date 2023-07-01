type ('f,'g) t =
  | Z : ('f,'f) t
  | S : 'a -> (('a -> 'f), ('f,'g) t -> 'g) t

let rec apply: type f g. f -> (f,g) t -> g =
  fun k t -> match t with
  | Z -> k (* type g = f *)
  | S x -> apply (k x) (* type g = (f,g) t -> g *)

let (!) x = S x (* prefix *)

(* top level *)
# apply List.map !(fun x -> x+1) ![1;2;3] Z
