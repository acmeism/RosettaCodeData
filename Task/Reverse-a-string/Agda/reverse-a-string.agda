module ReverseString where

open import Data.String using (String ; fromList ; toList)
open import Data.List using (reverse)

reverse-string : String → String
reverse-string s = fromList (reverse (toList s))
