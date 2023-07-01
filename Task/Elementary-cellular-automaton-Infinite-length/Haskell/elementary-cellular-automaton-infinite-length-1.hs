{-# LANGUAGE DeriveFunctor #-}

import Control.Comonad
import Data.InfList (InfList (..), (+++))
import qualified Data.InfList as Inf

data Cells a = Cells (InfList a) a (InfList a) deriving Functor

view n (Cells l x r) = reverse (Inf.take n l) ++ [x] ++ (Inf.take n r)

fromList []     = fromList [0]
fromList (x:xs) = let zeros = Inf.repeat 0
                  in Cells zeros x (xs +++ zeros)
