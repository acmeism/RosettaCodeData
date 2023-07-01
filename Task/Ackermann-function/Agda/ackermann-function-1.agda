module Ackermann where

open import Data.Nat using (ℕ ; zero ; suc ; _+_)

ack : ℕ → ℕ → ℕ
ack zero n = n + 1
ack (suc m) zero = ack m 1
ack (suc m) (suc n) = ack m (ack (suc m) n)


open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.String using (String)
open import Data.Nat.Show using (show)

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text as T #-}
{-# COMPILE GHC putStrLn = putStrLn . T.unpack #-}

main : IO ⊤
main = putStrLn (show (ack 3 9))


-- Output:
-- 4093
