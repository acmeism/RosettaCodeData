module reverse_string where

open import Data.String
open import Data.List

reverse_string : String → String
reverse_string s = fromList (reverse (toList s))
