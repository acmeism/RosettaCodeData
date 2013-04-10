module VShuffle (shuffle) where

import Data.List (mapAccumL)
import System.Random
import Control.Monad.ST
import qualified Data.Vector as V
import qualified Data.Vector.Generic.Mutable as M

-- Generate a list of array index pairs, each corresponding to a swap.
pairs :: (Enum a, Random a, RandomGen g) => a -> a -> g -> [(a, a)]
pairs l u r = snd $ mapAccumL step r [l..pred u]
    where step r i = let (j, r') = randomR (i, u) r in (r', (i, j))

-- Return a random permutation of the list.  We use the algorithm described in
-- http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle#The_modern_algorithm.
shuffle :: (RandomGen g) => [a] -> g -> [a]
shuffle xs r = V.toList . runST $ do
                 v <- V.unsafeThaw $ V.fromList xs
                 mapM_ (uncurry $ M.swap v) $ pairs 0 (M.length v - 1) r
                 V.unsafeFreeze v
