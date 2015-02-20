Require Import List.

Fixpoint prisoo' nd n k accu :=
  match nd with
    | O => rev accu
    | S nd' => let ra := match k with
                 | O => (true, S n, (n + n))
                 | S k' => (false, n, k')
               end in
               prisoo' nd' (snd (fst ra)) (snd ra) ((fst (fst ra))::accu)
  end.

Definition prisoo cells := prisoo' cells 1 0 nil.
