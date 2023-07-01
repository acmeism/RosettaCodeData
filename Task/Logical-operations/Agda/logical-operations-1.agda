module AndOrNot where

open import Data.Bool using (Bool ; false ; true ; _∧_ ; _∨_ ; not)
open import Data.Product using (_,_ ; _×_)

test : Bool → Bool → Bool × Bool × Bool
test a b = a ∧ b , a ∨ b , not a
