import Control.Monad.State
import Data.Array (Array, listArray, (!), (//))
import qualified Data.Array as A

deBruijn :: [a] -> Int -> [a]
deBruijn s n =
  let
    k = length s

    db :: Int -> Int -> State (Array Int Int) [Int]
    db t p =
      if t > n
      then
        if n `mod` p == 0
        then get >>= \a -> return [ a ! k | k <- [1 .. p]]
        else return []
      else do
        a <- get
        x <- setArray t (a ! (t-p)) >> db (t+1) p
        a <- get
        y <- sequence [ setArray t j >> db (t+1) t
                      | j <- [a ! (t-p) + 1 .. k - 1] ]
        return $ x ++ concat y

    setArray i x = modify (// [(i, x)])

    seqn = db 1 1 `evalState` listArray (0, k*n-1) (repeat 0)

  in [ s !! i | i <- seqn ++ take (n-1) seqn ]
