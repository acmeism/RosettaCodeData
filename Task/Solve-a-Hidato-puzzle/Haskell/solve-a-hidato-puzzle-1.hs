{-# LANGUAGE TupleSections #-}
{-# LANGUAGE Rank2Types #-}

import qualified Data.IntMap as I
import Data.IntMap (IntMap)
import Data.List
import Data.Maybe
import Data.Time.Clock

data BoardProblem = Board
  { cells :: IntMap (IntMap Int)
  , endVal :: Int
  , onePos :: (Int, Int)
  , givens :: [Int]
  } deriving (Show, Eq)

tupIns x y v m = I.insert x (I.insert y v (I.findWithDefault I.empty x m)) m

tupLookup x y m = I.lookup x m >>= I.lookup y

makeBoard =
  (\x ->
      x
      { givens = dropWhile (<= 1) $ sort $ givens x
      }) .
  foldl' --'
    f
    (Board I.empty 0 (0, 0) []) .
  concatMap (zip [0 ..]) . zipWith (\y w -> map (y, ) $ words w) [0 ..]
  where
    f bd (x, (y, v)) =
      if v == "."
        then bd
        else Board
               (tupIns x y (read v) (cells bd))
               (if read v > endVal bd
                  then read v
                  else endVal bd)
               (if v == "1"
                  then (x, y)
                  else onePos bd)
               (read v : givens bd)

hidato brd = listToMaybe $ h 2 (cells brd) (onePos brd) (givens brd)
  where
    h nval pmap (x, y) gs
      | nval == endVal brd = [pmap]
      | nval == head gs =
        if null nvalAdj
          then []
          else h (nval + 1) pmap (fst $ head nvalAdj) (tail gs)
      | not $ null nvalAdj = h (nval + 1) pmap (fst $ head nvalAdj) gs
      | otherwise = hEmptyAdj
      where
        around =
          [ (x - 1, y - 1)
          , (x, y - 1)
          , (x + 1, y - 1)
          , (x - 1, y)
          , (x + 1, y)
          , (x - 1, y + 1)
          , (x, y + 1)
          , (x + 1, y + 1)
          ]
        lkdUp = map (\(x, y) -> ((x, y), tupLookup x y pmap)) around
        nvalAdj = filter ((== Just nval) . snd) lkdUp
        hEmptyAdj =
          concatMap
            (\((nx, ny), _) -> h (nval + 1) (tupIns nx ny nval pmap) (nx, ny) gs) $
          filter ((== Just 0) . snd) lkdUp

printCellMap cellmap = putStrLn $ concat strings
  where
    maxPos = xyBy I.findMax maximum
    minPos = xyBy I.findMin minimum
    xyBy :: (forall a. IntMap a -> (Int, a)) -> ([Int] -> Int) -> (Int, Int)
    xyBy a b = (fst (a cellmap), b $ map (fst . a . snd) $ I.toList cellmap)
    strings =
      map
        f
        [ (x, y)
        | y <- [snd minPos .. snd maxPos]
        , x <- [fst minPos .. fst maxPos] ]
    f (x, y) =
      let z =
            if x == fst maxPos
              then "\n"
              else " "
      in case tupLookup x y cellmap of
           Nothing -> "  " ++ z
           Just n ->
             (if n < 10
                then ' ' : show n
                else show n) ++
             z

main = do
  let sampleBoard = makeBoard sample
  printCellMap $ cells sampleBoard
  printCellMap $ fromJust $ hidato sampleBoard

sample =
  [ " 0 33 35  0  0"
  , " 0  0 24 22  0"
  , " 0  0  0 21  0  0"
  , " 0 26  0 13 40 11"
  , "27  0  0  0  9  0  1"
  , ".  .   0  0 18  0  0"
  , ".  .  .  .   0  7  0  0"
  , ".  .  .  .  .  .   5  0"
  ]
