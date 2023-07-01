import Data.List (nub, permutations, sort)

digitShuffleSuccessors :: Integer -> [Integer]
digitShuffleSuccessors n =
  (fmap . (+) <*> (nub . sort . concatMap go . permutations . show)) n
  where
    go ds
      | 0 >= delta = []
      | otherwise = [delta]
      where
        delta = (read ds :: Integer) - n

--------------------------- TEST ---------------------------
main :: IO ()
main =
  putStrLn $
  fTable
    "Taking up to 5 digit-shuffle successors of a positive integer:\n"
    show
    (\xs ->
        let harvest = take 5 xs
        in rjust
             12
             ' '
             (show (length harvest) <> " of " <> show (length xs) <> ": ") <>
           show harvest)
    digitShuffleSuccessors
    [0, 9, 12, 21, 12453, 738440, 45072010, 95322020]

------------------------- DISPLAY --------------------------
fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  unlines $
  s : fmap (((<>) . rjust w ' ' . xShow) <*> ((" -> " <>) . fxShow . f)) xs
  where
    w = maximum (length . xShow <$> xs)

rjust :: Int -> Char -> String -> String
rjust n c = drop . length <*> (replicate n c <>)
