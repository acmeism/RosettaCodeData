Fixpoint Arity (A B: Set) (n: nat): Set := match n with
|O => B
|S n' => A -> (Arity A B n')
end.
