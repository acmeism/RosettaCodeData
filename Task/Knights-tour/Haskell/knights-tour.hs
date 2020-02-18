{-# LANGUAGE TupleSections #-}

import Data.List (minimumBy, (\\), intercalate, sort)
import Data.Ord (comparing)
import Data.Char (ord, chr)
import Data.Bool (bool)

type Square = (Int, Int)

knightTour :: [Square] -> [Square]
knightTour moves
  | null possibilities = reverse moves
  | otherwise = knightTour $ newSquare : moves
  where
    newSquare = minimumBy (comparing (length . findMoves)) possibilities
    possibilities = findMoves $ head moves
    findMoves = (\\ moves) . knightOptions

knightOptions :: Square -> [Square]
knightOptions (x, y) =
  knightMoves >>=
  (\(i, j) ->
      let a = x + i
          b = y + j
      in bool [] [(a, b)] (onBoard a && onBoard b))

knightMoves :: [(Int, Int)]
knightMoves =
  let deltas = [id, negate] <*> [1, 2]
  in deltas >>=
     (\i -> deltas >>= (bool [] . return . (i, )) <*> ((abs i /=) . abs))

onBoard :: Int -> Bool
onBoard = (&&) . (0 <) <*> (9 >)

-- TEST ---------------------------------------------------
startPoint = "e5"

algebraic :: (Int, Int) -> String
algebraic (x, y) = [chr (x + 96), chr (y + 48)]

main :: IO ()
main =
  printTour $
  algebraic <$> knightTour [(\[x, y] -> (ord x - 96, ord y - 48)) startPoint]
  where
    printTour [] = return ()
    printTour tour = do
      putStrLn $ intercalate " -> " $ take 8 tour
      printTour $ drop 8 tour
