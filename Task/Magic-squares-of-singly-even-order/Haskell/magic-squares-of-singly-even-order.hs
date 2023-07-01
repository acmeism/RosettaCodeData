import qualified Data.Map.Strict as M
import Data.List (transpose, intercalate)
import Data.Maybe (fromJust, isJust)
import Control.Monad (forM_)
import Data.Monoid ((<>))

magic :: Int -> [[Int]]
magic n = mapAsTable ((4 * n) + 2) (hiResMap n)

-- Order of square -> sequence numbers keyed by cartesian coordinates
hiResMap :: Int -> M.Map (Int, Int) Int
hiResMap n =
  let mapLux = luxMap n
      mapSiam = siamMap n
  in M.fromList $
     foldMap
       (\(xy, n) ->
           luxNums xy (fromJust (M.lookup xy mapLux)) ((4 * (n - 1)) + 1))
       (M.toList mapSiam)

-- LUX table coordinate -> L|U|X -> initial number -> 4 numbered coordinates
luxNums :: (Int, Int) -> Char -> Int -> [((Int, Int), Int)]
luxNums xy lux n =
  zipWith (\x d -> (x, n + d)) (hiRes xy) $
  case lux of
    'L' -> [3, 0, 1, 2]
    'U' -> [0, 3, 1, 2]
    'X' -> [0, 3, 2, 1]
    _ -> [0, 0, 0, 0]

-- Size of square -> integers keyed by coordinates -> rows of integers
mapAsTable :: Int -> M.Map (Int, Int) Int -> [[Int]]
mapAsTable nCols xyMap =
  let axis = [0 .. nCols - 1]
  in fmap (fromJust . flip M.lookup xyMap) <$>
     (axis >>= \y -> [axis >>= \x -> [(x, y)]])

-- Dimension of LUX table -> LUX symbols keyed by coordinates
luxMap :: Int -> M.Map (Int, Int) Char
luxMap n =
  (M.fromList . concat) $
  zipWith
    (\y xs -> (zipWith (\x c -> ((x, y), c)) [0 ..] xs))
    [0 ..]
    (luxPattern n)

-- LUX dimension -> square of L|U|X cells with two mixed rows
luxPattern :: Int -> [String]
luxPattern n =
  let d = (2 * n) + 1
      [ls, us] = replicate n <$> "LU"
      [lRow, xRow] = replicate d <$> "LX"
  in replicate n lRow <> [ls <> ('U' : ls)] <> [us <> ('L' : us)] <>
     replicate (n - 1) xRow

-- Highest zero-based index of grid -> Siamese indices keyed by coordinates
siamMap :: Int -> M.Map (Int, Int) Int
siamMap n =
  let uBound = (2 * n)
      sPath uBound sMap (x, y) n =
        let newMap = M.insert (x, y) n sMap
        in if y == uBound && x == quot uBound 2
             then newMap
             else sPath uBound newMap (nextSiam uBound sMap (x, y)) (n + 1)
  in sPath uBound (M.fromList []) (n, 0) 1

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

-- LUX cell coordinate -> four coordinates at higher resolution
hiRes :: (Int, Int) -> [(Int, Int)]
hiRes (x, y) =
  let [col, row] = (* 2) <$> [x, y]
      [col1, row1] = succ <$> [col, row]
  in [(col, row), (col1, row), (col, row1), (col1, row1)]

-- TESTS ----------------------------------------------------------------------
checked :: [[Int]] -> (Int, Bool)
checked square = (h, all (h ==) t)
  where
    diagonals = fmap (flip (zipWith (!!)) [0 ..]) . ((:) <*> (return . reverse))
    h:t = sum <$> square <> transpose square <> diagonals square

table :: String -> [[String]] -> [String]
table delim rows =
  let justifyRight c n s = drop (length s) (replicate n c <> s)
  in intercalate delim <$>
     transpose
       ((fmap =<< justifyRight ' ' . maximum . fmap length) <$> transpose rows)

main :: IO ()
main =
  forM_ [1, 2, 3] $
  \n -> do
    let test = magic n
    putStrLn $ unlines (table " " (fmap show <$> test))
    print $ checked test
    putStrLn ""
