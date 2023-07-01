module EvenOrOdd where

open import Data.Bool using (Bool; false; true)
open import Data.Nat using (ℕ; zero; suc)

even : ℕ → Bool
odd  : ℕ → Bool

even zero    = true
even (suc n) = odd n

odd zero    = false
odd (suc n) = even n
