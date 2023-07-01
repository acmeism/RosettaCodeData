{-# LANGUAGE TupleSections #-}

import Control.Monad (forM_)
import Data.List (intercalate, transpose)
import qualified Data.Map.Strict as M
import Data.Maybe (fromJust, isJust)

magic :: Int -> [[Int]]
magic = mapAsTable <*> siamMap

----------------- SIAMESE METHOD FUNCTIONS ---------------

-- Highest zero-based index of grid ->
-- 'Siamese' indices keyed by coordinates
siamMap :: Int -> M.Map (Int, Int) Int
siamMap n
  | odd n = go n
  | otherwise = M.fromList []
  where
    go n = sPath uBound (M.fromList []) (quot uBound 2, 0) 1
      where
        h = quot n 2
        uBound = n - 1
        sPath uBound sMap (x, y) h =
          let newMap = M.insert (x, y) h sMap
           in if y == uBound && x == quot uBound 2
                then newMap
                else
                  sPath
                    uBound
                    newMap
                    (nextSiam uBound sMap (x, y))
                    (succ h)

-- Highest index of square -> Siam xys so far -> xy ->
-- next xy coordinate
nextSiam :: Int -> M.Map (Int, Int) Int -> (Int, Int) -> (Int, Int)
nextSiam uBound sMap (x, y) =
  let alt (a, b)
        -- Top right corner ?
        | a > uBound && b < 0 = (uBound, 1)
        -- beyond right edge ?
        | a > uBound = (0, b)
        -- above top edge ?
        | b < 0 = (a, uBound)
        -- already filled ?
        | isJust (M.lookup (a, b) sMap) = (a - 1, b + 2)
        | otherwise = (a, b) -- Up one, right one.
   in alt (x + 1, y - 1)

---------------- DISPLAY AND TEST FUNCTIONS --------------

-- Size of square -> integers keyed by coordinates
-- -> rows of integers
mapAsTable :: Int -> M.Map (Int, Int) Int -> [[Int]]
mapAsTable nCols xyMap =
  let axis = [0 .. nCols - 1]
   in fmap (fromJust . flip M.lookup xyMap)
        <$> (axis >>= \y -> [(,y) <$> axis])

checked :: [[Int]] -> (Int, Bool)
checked square =
  let diagonals =
        fmap (flip (zipWith (!!)) [0 ..])
          . ( (:)
                <*> (return . reverse)
            )
      h : t =
        sum <$> square
          <> transpose square
          <> diagonals square
   in (h, all (h ==) t)

table :: String -> [[String]] -> [String]
table delim rows =
  let justifyRight c n s =
        drop
          (length s)
          (replicate n c <> s)
   in intercalate delim
        <$> transpose
          ( (fmap =<< justifyRight ' ' . maximum . fmap length)
              <$> transpose rows
          )

main :: IO ()
main =
  forM_ [3, 5, 7] $
    \n -> do
      let test = magic n
      putStrLn $ unlines (table " " (fmap show <$> test))
      print $ checked test
      putStrLn ""
