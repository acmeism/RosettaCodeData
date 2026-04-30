Require Import List.
Fixpoint build_list_aux {A: Set} (acc: list A) (n : nat): Arity A (list A) n := match n with
|O => acc
|S n' => fun (val: A) => build_list_aux (acc ++ (val :: nil)) n'
end.
