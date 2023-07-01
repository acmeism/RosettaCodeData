{-# LANGUAGE DeriveFunctor #-}

import Control.Comonad
import Data.InfList (InfList (..))
import qualified Data.InfList as Inf

data Cycle a = Cycle Int a a (InfList a) deriving Functor

view (Cycle n _ x r) = Inf.take n (x ::: r)

fromList []  = let a = a in Cycle 0 a a (Inf.repeat a)
-- zero cycle length ensures that elements of the empty cycle will never be accessed
fromList lst = let x:::r = Inf.cycle lst
               in Cycle (length lst) (last lst) x r
