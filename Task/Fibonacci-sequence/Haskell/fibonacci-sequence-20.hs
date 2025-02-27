import Data.Functor.Identity (Identity (..))

fibs :: [Integer]
fibs = runIdentity (hsequence (repeat f))
    where f []  = Identity 1
          f [_] = Identity 1
          f xs  = Identity ((xs !! (i-1)) + (xs !! i))
              where i = length xs-1
