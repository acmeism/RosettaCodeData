-- We use a couple of GHC extensions to make the program cooler.  They let us
-- use / as an operator and 13 as a literal at the type level.  (The library
-- also provides the fancy Zahlen (ℤ) symbol as a synonym for Integer.)

{-# Language DataKinds #-}
{-# Language TypeOperators #-}

import Data.Modular

f :: ℤ/13 -> ℤ/13
f x = x^100 + x + 1

main :: IO ()
main = print (f 10)
