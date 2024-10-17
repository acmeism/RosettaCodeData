type 'a mu = Roll of ('a mu -> 'a);;

let unroll (Roll x) = x;;

let fix f = (fun x a -> f (unroll x x) a) (Roll (fun x a -> f (unroll x x) a));;

let fac f = function
    0 -> 1
  | n -> n * f (n-1)
;;

let fib f = function
    0 -> 0
  | 1 -> 1
  | n -> f (n-1) + f (n-2)
;;

(* val unroll : 'a mu -> 'a mu -> 'a = <fun>
val fix : (('a -> 'b) -> 'a -> 'b) -> 'a -> 'b = <fun>
val fac : (int -> int) -> int -> int = <fun>
val fib : (int -> int) -> int -> int = <fun> *)

fix fac 5;;
(* - : int = 120 *)

fix fib 8;;
(* - : int = 21 *)
