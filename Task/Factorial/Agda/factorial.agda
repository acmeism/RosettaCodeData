factorial : ℕ → ℕ
factorial zero = 1
factorial (suc n) = suc n * factorial n
