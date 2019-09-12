even : ℕ → Bool
odd  : ℕ → Bool

even zero    = true
even (suc n) = odd n

odd zero    = false
odd (suc n) = even n
