import Data.Char (ord, chr)
import Data.Ord (comparing)
import Data.List (minimumBy, (\\), intercalate, sort)

type Square = (Int, Int)

board :: [Square]
board =
  [ (x, y)
  | x <- [1 .. 8]
  , y <- [1 .. 8] ]

knightMoves :: Square -> [Square]
knightMoves (x, y) = filter (`elem` board) jumps
  where
    jumps =
      [ (x + i, y + j)
      | i <- jv
      , j <- jv
      , abs i /= abs j ]
    jv = [1, -1, 2, -2]

knightTour :: [Square] -> [Square]
knightTour moves
  | null candMoves = reverse moves
  | otherwise = knightTour $ newSquare : moves
  where
    newSquare = minimumBy (comparing (length . findMoves)) candMoves
    candMoves = findMoves $ head moves
    findMoves = (\\ moves) . knightMoves

toSq :: String -> (Int, Int)
toSq [x, y] = (ord x - 96, ord y - 48)

toAlg :: (Int, Int) -> String
toAlg (x, y) = [chr (x + 96), chr (y + 48)]

-- TEST -----------------------------------------------------------------------
sq :: (Int, Int)
sq = toSq "e5" -- Input: starting position on the board, e.g. (5, 5) as "e5"

main :: IO ()
main = printTour $ toAlg <$> knightTour [sq]
  where
    printTour [] = return ()
    printTour tour = do
      putStrLn $ intercalate " -> " $ take 8 tour
      printTour $ drop 8 tour
