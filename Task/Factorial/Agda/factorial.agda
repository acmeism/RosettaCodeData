module Factorial where

open import Data.Nat using (ℕ ; zero ; suc ; _*_)

factorial : (n : ℕ) → ℕ
factorial zero = 1
factorial (suc n) = (suc n) * (factorial n)
