Lemma transparent_plus_zero: forall n, n + O = n.
intros n; induction n.
- reflexivity.
- simpl; rewrite IHn; trivial.
Defined.

Lemma transparent_plus_S: forall n m, n + S m = S n + m .
intros n; induction n; intros m.
- reflexivity.
- simpl; f_equal; rewrite IHn; reflexivity.
Defined.
