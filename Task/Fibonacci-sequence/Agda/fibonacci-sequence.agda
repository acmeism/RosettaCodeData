module FibonacciSequence where

open import Data.Nat using (ℕ ; zero ; suc ; _+_)

rec_fib : (m : ℕ) -> (a : ℕ) -> (b : ℕ) -> ℕ
rec_fib zero a b = a
rec_fib (suc k) a b = rec_fib k b (a + b)

fib : (n : ℕ) -> ℕ
fib n = rec_fib n zero (suc zero)
