Require Import Utf8.
Require Import List.

Unset Elimination Schemes.

(* Rose tree, with numbers on nodes *)
Inductive tree := Tree { value : nat ; children : list tree }.

Fixpoint height (t: tree) : nat :=
  1 + fold_left (λ n t, max n (height t)) (children t) 0.

Example leaf n : tree := {| value := n ; children := nil |}.

Example t2 : tree := {| value := 2 ; children := {| value := 4 ; children := leaf 7 :: nil |} :: leaf 5 :: nil |}.

Example t3 : tree := {| value := 3 ; children := {| value := 6 ; children := leaf 8 :: leaf 9 :: nil |} :: nil |}.

Example t9 : tree := {| value := 1 ; children := t2 :: t3 :: nil |}.

Fixpoint preorder (t: tree) : list nat :=
  let '{| value := n ; children := c |} := t in
  n :: flat_map preorder c.

Fixpoint inorder (t: tree) : list nat :=
  let '{| value := n ; children := c |} := t in
  match c with
  | nil => n :: nil
  | ℓ :: r => inorder ℓ ++ n :: flat_map inorder r
  end.

Fixpoint postorder (t: tree) : list nat :=
  let '{| value := n ; children := c |} := t in
  flat_map postorder c ++ n :: nil.

(* Auxiliary function for levelorder, which operates on forests *)
(* Since the recursion is tricky, it relies on a fuel parameter which obviously decreases. *)
Fixpoint levelorder_forest (fuel: nat) (f: list tree) : list nat:=
  match fuel with
  | O => nil
  | S fuel' =>
    let '(p, f) := fold_right (λ t r, let '(x, f) := r in (value t :: x, children t ++ f) ) (nil, nil) f in
    p ++ levelorder_forest fuel' f
  end.

Definition levelorder (t: tree) : list nat :=
  levelorder_forest (height t) (t :: nil).

Compute preorder t9.
Compute inorder t9.
Compute postorder t9.
Compute levelorder t9.
