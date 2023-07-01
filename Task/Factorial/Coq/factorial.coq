Fixpoint factorial (n : nat) : nat :=
  match n with
    | 0 => 1
    | S k => (S k) * (factorial k)
  end.
