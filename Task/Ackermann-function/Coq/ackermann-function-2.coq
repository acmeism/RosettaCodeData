Require Import Utf8.

Section FOLD.
  Context {A : Type} (f : A → A) (a : A).
  Fixpoint fold (n : nat) : A :=
    match n with
      | O => a
      | S k => f (fold k)
    end.
End FOLD.

Definition ackermann : nat → nat → nat :=
  fold (λ g, fold g (g (S O))) S.
