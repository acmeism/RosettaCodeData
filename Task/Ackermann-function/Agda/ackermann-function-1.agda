open import Data.Nat
open import Data.Nat.Show
open import IO

module Ackermann where

ack : ℕ -> ℕ -> ℕ
ack zero n = n + 1
ack (suc m) zero = ack m 1
ack (suc m) (suc n) = ack m (ack (suc m) n)

main = run (putStrLn (show (ack 3 9)))
