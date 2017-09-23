import qualified Data.Map.Strict as M
import Control.Monad (forM_)
import Data.Maybe (isJust, fromJust)
import Data.List (transpose, intercalate)

magic :: Int -> [[Int]]
magic = mapAsTable <*> siamMap

-- SIAMESE METHOD FUNCTIONS ----------------------------------------------------

-- Highest zero-based index of grid -> 'Siamese' indices keyed by coordinates
siamMap :: Int -> M.Map (Int, Int) Int
siamMap n =
  if odd n
    then let h = quot n 2
             uBound = n - 1
             sPath uBound sMap (x, y) h =
               let newMap = M.insert (x, y) h sMap
               in if y == uBound && x == quot uBound 2
                    then newMap
                    else sPath
                           uBound
                           newMap
                           (nextSiam uBound sMap (x, y))
                           (h + 1)
         in sPath uBound (M.fromList []) (quot uBound 2, 0) 1
    else M.fromList []

-- Highest index of square -> Siam xys so far -> xy -> next xy coordinate
nextSiam :: Int -> M.Map (Int, Int) Int -> (Int, Int) -> (Int, Int)
nextSiam uBound sMap (x, y) =
  let alt (a, b)
        | a > uBound && b < 0 = (uBound, 1) -- Top right corner ?
        | a > uBound = (0, b) -- beyond right edge ?
        | b < 0 = (a, uBound) -- above top edge ?
        | isJust (M.lookup (a, b) sMap) = (a - 1, b + 2) -- already filled ?
        | otherwise = (a, b) -- Up one, right one.
  in alt (x + 1, y - 1)

-- DISPLAY AND TEST FUNCTIONS --------------------------------------------------

-- Size of square -> integers keyed by coordinates -> rows of integers
mapAsTable :: Int -> M.Map (Int, Int) Int -> [[Int]]
mapAsTable nCols xyMap =
  let axis = [0 .. nCols - 1]
  in fmap (fromJust . flip M.lookup xyMap) <$>
     (axis >>= \y -> [axis >>= \x -> [(x, y)]])

checked :: [[Int]] -> (Int, Bool)
checked square =
  let diagonals =
        fmap (flip (zipWith (!!)) [0 ..]) . ((:) <*> (return . reverse))
      h:t = sum <$> square ++ transpose square ++ diagonals square
  in (h, all (h ==) t)

table :: String -> [[String]] -> [String]
table delim rows =
  let justifyRight c n s = drop (length s) (replicate n c ++ s)
  in intercalate delim <$>
     transpose
       ((fmap =<< justifyRight ' ' . maximum . fmap length) <$> transpose rows)

main :: IO ()
main =
  forM_ [3, 5, 7] $
  \n -> do
    let test = magic n
    putStrLn $ unlines (table " " (fmap show <$> test))
    print $ checked test
    putStrLn ""
