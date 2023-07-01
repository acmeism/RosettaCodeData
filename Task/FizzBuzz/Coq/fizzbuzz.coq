Require Import Coq.Lists.List.
(* https://coq.inria.fr/library/Coq.Lists.List.html *)

Require Import Coq.Strings.String.
(* https://coq.inria.fr/library/Coq.Strings.String.html *)

Require Import Coq.Strings.Ascii.
(* https://coq.inria.fr/library/Coq.Strings.Ascii.html *)

Require Import Coq.Init.Nat.
(* https://coq.inria.fr/library/Coq.Init.Nat.html *)


(** Definition of [string_of_nat] to convert natural numbers to strings. *)

Definition ascii_of_digit (n : nat) : ascii :=
  ascii_of_nat (n + 48).

Definition is_digit (n : nat) : bool :=
  andb (0 <=? n) (n <=? 9).

Fixpoint rec_string_of_nat (counter : nat) (n : nat) (acc : string) : string :=
  match counter with
    | 0 => EmptyString
    | S c =>
      if (is_digit n)
      then String (ascii_of_digit n) acc
      else rec_string_of_nat c (n / 10) (String (ascii_of_digit (n mod 10)) acc)
  end.
(** The counter is only used to ensure termination. *)

Definition string_of_nat (n : nat) : string :=
  rec_string_of_nat n n EmptyString.


(** The FizzBuzz problem. *)

Definition fizz : string :=
  "Fizz".

Definition buzz : string :=
  "Buzz".

Definition new_line : string :=
  String (ascii_of_nat 10) EmptyString.

Definition is_divisible_by (n : nat) (k : nat) : bool :=
  (n mod k) =? 0.

Definition get_term (n : nat) : string :=
  if (is_divisible_by n 15) then fizz ++ buzz
  else if (is_divisible_by n 3) then fizz
  else if (is_divisible_by n 5) then buzz
  else (string_of_nat n).

Definition range (a : nat) (b : nat) : list nat :=
  seq a b.

Definition get_terms (n : nat) : list string :=
  map get_term (range 1 n).

Definition fizz_buzz : string :=
  concat new_line (get_terms 100).

(** This shows the string. *)
Eval compute in fizz_buzz.
