import Data.Array.ST
import Data.STRef
import Control.Monad
import Control.Monad.ST
import Control.Arrow
import System.Random

shuffle :: RandomGen g => [a] -> g -> ([a], g)
shuffle list g = runST $ do
    r <- newSTRef g
    let rand range = liftM (randomR range) (readSTRef r) >>=
            runKleisli (second (Kleisli $ writeSTRef r) >>> arr fst)
    a <- newAry (1, len) list
    forM_ [len, len - 1 .. 2] $ \n -> do
        k <- rand (1, n)
        liftM2 (,) (readArray a k) (readArray a n) >>=
           runKleisli (Kleisli (writeArray a n) *** Kleisli (writeArray a k))
    liftM2 (,) (getElems a) (readSTRef r)
  where len = length list
        newAry :: (Int, Int) -> [a] -> ST s (STArray s Int a)
        newAry = newListArray
