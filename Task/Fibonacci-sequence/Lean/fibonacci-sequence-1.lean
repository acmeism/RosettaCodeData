-- Our first implementation is the usual recursive definition:
def fib1 : ℕ → ℕ
| 0       := 0
| 1       := 1
| (n + 2) := fib1 n + fib1 (n + 1)


-- We can give a second more efficient implementation using an auxiliary function:
def fib_aux : ℕ → ℕ → ℕ → ℕ
| 0 a b       := b
| (n + 1) a b := fib_aux n (a + b) a

def fib2 : ℕ → ℕ
| n := fib_aux n 1 0


-- Use #eval to check computations:
#eval fib1 20
#eval fib2 20
