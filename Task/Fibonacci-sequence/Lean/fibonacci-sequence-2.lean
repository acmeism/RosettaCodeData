-- Naive version
def fib1 (n : Nat) : Nat :=
  match n with
  | 0 => 0
  | 1 => 1
  | (k + 2) => fib1 k + fib1 (k + 1)

-- More efficient version
def fib_aux (n : Nat) (a : Nat) (b : Nat) : Nat :=
  match n with
  | 0 => b
  | (k + 1) => fib_aux k (a + b) a

def fib2 (n : Nat) : Nat :=
  fib_aux n 1 0

-- Examples
#eval fib1 20
#eval fib2 20
