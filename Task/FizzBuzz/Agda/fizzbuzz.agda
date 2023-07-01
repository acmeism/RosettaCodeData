module FizzBuzz where

open import Agda.Builtin.IO using (IO)

open import Agda.Builtin.Unit renaming (⊤ to Unit)

open import Data.Bool using (Bool ; false ; true ; if_then_else_)

open import Data.Nat using (ℕ ; zero ; suc ; _≡ᵇ_ ; _%_)

open import Data.Nat.Show using (show)

open import Data.List using (List ; [] ; _∷_ ; map)

open import Data.String using (String ; _++_ ; unlines)

postulate putStrLn : String -> IO Unit
{-# FOREIGN GHC import qualified Data.Text as T #-}
{-# COMPILE GHC putStrLn = putStrLn . T.unpack #-}

fizz : String
fizz = "Fizz"

buzz : String
buzz = "Buzz"

_isDivisibleBy_ : (n : ℕ) -> (m : ℕ) -> Bool
n isDivisibleBy zero = false
n isDivisibleBy (suc k) = ((n % (suc k)) ≡ᵇ 0)

getTerm : (n : ℕ) -> String
getTerm n =
  if (n isDivisibleBy 15) then (fizz ++ buzz)
  else if (n isDivisibleBy 3) then fizz
  else if (n isDivisibleBy 5) then buzz
  else (show n)

range : (a : ℕ) -> (b : ℕ) -> List (ℕ)
range k zero = []
range k (suc m) = k ∷ (range (suc k) m)

getTerms : (n : ℕ) -> List (String)
getTerms n = map getTerm (range 1 n)

fizzBuzz : String
fizzBuzz = unlines (getTerms 100)

main : IO Unit
main = putStrLn fizzBuzz
