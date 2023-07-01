import Data.Bifunctor (bimap)
import Data.Char (chr, ord)
import Data.List (intercalate, minimumBy, sort, (\\))
import Data.Ord (comparing)
import Control.Monad (join)

---------------------- KNIGHT'S TOUR ---------------------

type Square = (Int, Int)

knightTour :: [Square] -> [Square]
knightTour moves
  | null possibilities = reverse moves
  | otherwise = knightTour $ newSquare : moves
  where
    newSquare =
      minimumBy
        (comparing (length . findMoves))
        possibilities
    possibilities = findMoves $ head moves
    findMoves = (\\ moves) . knightOptions

knightOptions :: Square -> [Square]
knightOptions (x, y) =
  knightMoves >>= go . bimap (+ x) (+ y)
  where
    go move
      | uncurry (&&) (both onBoard move) = [move]
      | otherwise = []

knightMoves :: [(Int, Int)]
knightMoves =
  ((>>=) <*> (\deltas n -> deltas >>= go n)) [1, 2, -1, -2]
  where
    go i x
      | abs i /= abs x = [(i, x)]
      | otherwise = []

onBoard :: Int -> Bool
onBoard = (&&) . (0 <) <*> (9 >)

both :: (a -> b) -> (a,  a) -> (b,  b)
both = join bimap

--------------------------- TEST -------------------------
startPoint :: String
startPoint = "e5"

algebraic :: (Int, Int) -> String
algebraic (x, y) = [chr (x + 96), chr (y + 48)]

main :: IO ()
main =
  printTour $
    algebraic
      <$> knightTour
        [(\[x, y] -> (ord x - 96, ord y - 48)) startPoint]
  where
    printTour [] = return ()
    printTour tour = do
      putStrLn $ intercalate " -> " $ take 8 tour
      printTour $ drop 8 tour
