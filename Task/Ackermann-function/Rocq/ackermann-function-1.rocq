Fixpoint ack (m : nat) : nat -> nat :=
  fix ack_m (n : nat) : nat :=
    match m with
      | 0 => S n
      | S pm =>
        match n with
          | 0 => ack pm 1
          | S pn => ack pm (ack_m pn)
        end
    end.


(*
  Example:
    A(3, 2) = 29
*)

Eval compute in ack 3 2.
