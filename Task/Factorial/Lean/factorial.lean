def factorial (n : Nat) : Nat :=
  match n with
  | 0 => 1
  | (k + 1) => (k + 1) * factorial (k)
