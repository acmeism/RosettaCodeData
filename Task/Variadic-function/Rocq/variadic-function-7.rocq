Require Import Vector.

Definition build_vector_aux {A: Set} (n: nat): forall (size_acc : nat) (acc: t A size_acc), Arity A (t A (size_acc + n)) n.
induction n; intros size_acc acc.
- rewrite transparent_plus_zero; apply acc. (*Just one argument, return the accumulator*)
- intros val. rewrite transparent_plus_S. apply IHn. (*Here we use the induction hypothesis. We just have to build the new accumulator*)
  apply shiftin; [apply val | apply acc]. (*Shiftin adds a term at the end of a vector*)
