type zero = Zero
type 'a succ = Succ

(* 1.1 *)
type _ nat =
  | Zero : zero nat
  | Succ : 'a nat -> 'a succ nat

(* 1.2 *)
type _ even =
  | Even_zero : zero even
  | Even_ss : 'a even -> 'a succ succ even

(* 2.1: define the addition relation *)
type (_, _, _) plus =
  | Plus_zero : ('a, zero, 'a) plus
  | Plus_succ : ('a, 'b, 'c) plus -> ('a, 'b succ, 'c succ) plus

(* 3.1 *)

(* Define the property: there exists a number 'sum that is the sum of 'a and 'b and is even. *)
type ('a, 'b) exists_plus_even = Exists_plus_even : ('a, 'b, 'sum) plus * 'sum even -> ('a, 'b) exists_plus_even

(* The proof that if a and b are even, there exists sum that is the sum of a and b that is even.
   This is a valid proof since it terminated, and it is total (no assert false, and the exhaustiveness
   test of pattern matching doesn't generate a warning) *)
let rec even_plus_even : type a b. a even -> b even -> (a, b) exists_plus_even =
  fun a_even b_even ->
    match b_even with
    | Even_zero ->
      Exists_plus_even (Plus_zero, a_even)
    | Even_ss b_even' ->
      let Exists_plus_even (plus, even) = even_plus_even a_even b_even' in
      Exists_plus_even (Plus_succ (Plus_succ plus), Even_ss even)

(* 3.3 *)

(* 0 + n = n *)
let rec plus_zero : type a. a nat -> (zero, a, a) plus = function
  | Zero -> Plus_zero
  | Succ a -> Plus_succ (plus_zero a)

(* a + b = n => (a + 1) + b = (n + 1) *)
let rec plus_succ_left : type a b sum. (a, b, sum) plus -> (a succ, b, sum succ) plus =
  function
  | Plus_zero -> Plus_zero
  | Plus_succ plus -> Plus_succ (plus_succ_left plus)

(* a + b = n => b + a = n *)
let rec plus_commutative : type a b sum. a nat -> (a, b, sum) plus -> (b, a, sum) plus =
  fun a plus ->
    match plus with
    | Plus_zero -> plus_zero a
    | Plus_succ plus' ->
      plus_succ_left (plus_commutative a plus')

