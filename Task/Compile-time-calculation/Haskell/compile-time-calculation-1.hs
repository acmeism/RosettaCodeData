module Factorial where
import Language.Haskell.TH.Syntax

fact n = product [1..n]

factQ :: Integer -> Q Exp
factQ = lift . fact
