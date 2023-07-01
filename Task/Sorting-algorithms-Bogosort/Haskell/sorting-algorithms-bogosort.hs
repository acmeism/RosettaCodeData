import System.Random
import Data.Array.IO
import Control.Monad

isSortedBy :: (a -> a -> Bool) -> [a] -> Bool
isSortedBy _ [] = True
isSortedBy f xs = all (uncurry f) . (zip <*> tail) $ xs


-- from http://www.haskell.org/haskellwiki/Random_shuffle
shuffle :: [a] -> IO [a]
shuffle xs = do
        ar <- newArray n xs
        forM [1..n] $ \i -> do
            j <- randomRIO (i,n)
            vi <- readArray ar i
            vj <- readArray ar j
            writeArray ar j vi
            return vj
  where
    n = length xs
    newArray :: Int -> [a] -> IO (IOArray Int a)
    newArray n xs =  newListArray (1,n) xs

bogosortBy :: (a -> a -> Bool) -> [a] -> IO [a]
bogosortBy f xs | isSortedBy f xs = return xs
                | otherwise       = shuffle xs >>= bogosortBy f

bogosort :: Ord a => [a] -> IO [a]
bogosort = bogosortBy (<)
