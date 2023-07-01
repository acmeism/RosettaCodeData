import Control.Monad (join)
import Data.List (maximumBy, transpose)
import Data.List.Split (chunksOf)
import Data.Ord (comparing)


magicSquare :: Int -> [[Int]]
magicSquare n
  | 1 == mod n 2 =
    applyN 2 (transpose . cycled) $
      plainSquare n
  | otherwise = []


plainSquare :: Int -> [[Int]]
plainSquare = chunksOf <*> enumFromTo 1 . (^ 2)


-------------------------- TEST ---------------------------
main :: IO ()
main =
  mapM_ putStrLn $
    showSquare . magicSquare <$> [3, 5, 7]


------------------------- GENERIC -------------------------
applyN :: Int -> (a -> a) -> a -> a
applyN n f = foldr (.) id (replicate n f)

cycled :: [[Int]] -> [[Int]]
cycled rows =
  let n = length rows
      d = quot n 2
   in zipWith
        (\d xs -> take n $ drop (n - d) (cycle xs))
        [d, subtract 1 d .. - d]
        rows

------------------------ FORMATTING ----------------------
justifyRight :: Int -> a -> [a] -> [a]
justifyRight n c = (drop . length) <*> (replicate n c <>)

showSquare :: Show a => [[a]] -> String
showSquare rows =
  ( (\xs w -> unlines ((justifyRight w ' ' =<<) <$> xs))
      <*> succ . maximum . fmap length . join
  )
    $ fmap show <$> rows
