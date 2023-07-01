module Matrix where

open import Data.Nat
open import Data.Vec

Matrix : (A : Set) → ℕ → ℕ → Set
Matrix A m n = Vec (Vec A m) n

transpose : ∀ {A m n} → Matrix A m n → Matrix A n m
transpose [] = replicate []
transpose (xs ∷ xss) = zipWith _∷_ xs (transpose xss)

a = (1 ∷ 2 ∷ 3 ∷ []) ∷ (4 ∷ 5 ∷ 6 ∷ []) ∷ []
b = transpose a
