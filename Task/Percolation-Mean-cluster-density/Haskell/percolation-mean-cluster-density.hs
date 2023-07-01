{-# language FlexibleContexts #-}
import Data.List
import Data.Maybe
import System.Random
import Control.Monad.State
import Text.Printf
import Data.Set (Set)
import qualified Data.Set  as S

type Matrix = [[Bool]]
type Cell = (Int, Int)
type Cluster = Set (Int, Int)

clusters :: Matrix -> [Cluster]
clusters m = unfoldr findCuster cells
  where
    cells = S.fromList [ (i,j) | (r, i) <- zip m [0..]
                               , (x, j) <- zip r [0..], x]

    findCuster s = do
      (p, ps) <- S.minView s
      return $ runState (expand p) ps

    expand p = do
      ns <- state $ extract (neigbours p)
      xs <- mapM expand $ S.elems ns
      return $ S.insert p $ mconcat xs

    extract s1 s2 = (s2 `S.intersection` s1, s2 S.\\ s1)
    neigbours (i,j) = S.fromList [(i-1,j),(i+1,j),(i,j-1),(i,j+1)]
    n = length m

showClusters :: Matrix -> String
showClusters m = unlines [ unwords [ mark (i,j)
                                   | j <- [0..n-1] ]
                         | i <- [0..n-1] ]
  where
    cls = clusters m
    n = length m
    mark c = maybe "." snd $ find (S.member c . fst) $ zip cls syms
    syms = sequence [['a'..'z'] ++ ['A'..'Z']]
------------------------------------------------------------

randomMatrices :: Int -> StdGen -> [Matrix]
randomMatrices n = clipBy n . clipBy n . randoms
  where
    clipBy n = unfoldr (Just . splitAt n)

randomMatrix n = head . randomMatrices n

tests :: Int -> StdGen -> [Int]
tests n = map (length . clusters) . randomMatrices n

task :: Int -> StdGen -> (Int, Double)
task n g = (n, result)
  where
    result = mean $ take 10 $ map density $ tests n g
    density c = fromIntegral c / fromIntegral n**2
    mean lst = sum lst / genericLength lst

main = newStdGen >>= mapM_ (uncurry (printf "%d\t%.5f\n")) . res
  where
    res = mapM task [10,50,100,500]
