module AndOrNot where


-- This part is to compute the values

open import Data.Bool using (Bool ; false ; true ; _∧_ ; _∨_ ; not)
open import Data.Product using (_,_ ; _×_)

test : Bool → Bool → Bool × Bool × Bool
test a b = a ∧ b , a ∨ b , not a


-- This part is to print the result

open import Agda.Builtin.IO using (IO)
open import Agda.Builtin.Unit using (⊤)
open import Data.String using (String ; _++_)
open import Data.Bool.Show using (show)

get-and-or-not-str : Bool × Bool × Bool → String
get-and-or-not-str (t₁ , t₂ , t₃) =
  "a and b: " ++ (show t₁) ++ ", " ++
  "a or b: " ++ (show t₂) ++ ", " ++
  "not a: " ++ (show t₃)

test-str : Bool → Bool → String
test-str a b = get-and-or-not-str (test a b)

postulate putStrLn : String → IO ⊤
{-# FOREIGN GHC import qualified Data.Text as T #-}
{-# COMPILE GHC putStrLn = putStrLn . T.unpack #-}

run : Bool → Bool → IO ⊤
run a b = putStrLn (test-str a b)

main : IO ⊤
main = run true false


--
-- This program outputs:
-- a and b: false, a or b: true, not a: false
--
