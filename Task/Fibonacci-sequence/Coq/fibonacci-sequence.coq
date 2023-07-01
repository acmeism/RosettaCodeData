Fixpoint rec_fib (m : nat) (a : nat) (b : nat) : nat :=
  match m with
    | 0 => a
    | S k => rec_fib k b (a + b)
  end.

Definition fib (n : nat) : nat :=
  rec_fib n 0 1 .
