def repeatf (f : Nat -> String) (n : Nat) : String :=
  match n with
  | 0 => "."
  | (k + 1) => (f k) ++ (repeatf f k)

def example1 : String :=
  repeatf (fun (x : Nat) => toString (x) ++ " ") (10)

#eval example1
