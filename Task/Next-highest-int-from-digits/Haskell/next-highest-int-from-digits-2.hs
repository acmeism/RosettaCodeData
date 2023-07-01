import Data.List (unfoldr)

------------------- MINIMAL DIGIT-SWAPS ------------------

digitShuffleSuccessors :: Integral b => b -> [b]
digitShuffleSuccessors n =
  unDigits <$> unfoldr nexts (go $ reversedDigits n)
  where
    go = minimalSwap . splitBy (>)
    nexts x
      | null x = Nothing
      | otherwise = Just (((,) <*> go . reverse) x)


minimalSwap :: Ord a => ([a], [a]) -> [a]
minimalSwap ([], x : y : xs) = reverse (y : x : xs)
minimalSwap ([], xs) = []
minimalSwap (_, []) = []
minimalSwap (reversedSuffix, pivot : prefix) =
  reverse (h : prefix) <> less <> (pivot : more)
  where
    (less, h : more) = break (> pivot) reversedSuffix


--------------------------- TEST -------------------------
main :: IO ()
main = do
  putStrLn $
    fTable
      ( "Taking up to 5 digit-shuffle successors "
          <> "of a positive integer:\n"
      )
      show
      ( \xs ->
          let harvest = take 5 xs
           in rjust
                12
                ' '
                ( show (length harvest) <> " of "
                    <> show (length xs)
                    <> ": "
                )
                <> show harvest
      )
      digitShuffleSuccessors
      [0, 9, 12, 21, 12453, 738440, 45072010, 95322020]
  putStrLn $
    fTable
      "Taking up to 10 digit-shuffle successors of a larger integer:\n"
      show
      (('\n' :) . unlines . fmap (("    " <>) . show))
      (take 10 . digitShuffleSuccessors)
      [9589776899767587796600]

------------------------- GENERIC ------------------------
reversedDigits :: Integral a => a -> [a]
reversedDigits 0 = [0]
reversedDigits n = go n
  where
    go 0 = []
    go x = rem x 10 : go (quot x 10)

splitBy :: (a -> a -> Bool) -> [a] -> ([a], [a])
splitBy f xs = go $ break (uncurry f) $ zip xs (tail xs)
  where
    go (ys, zs)
      | null ys = ([], xs)
      | otherwise = (fst (head ys) : map snd ys, map snd zs)

unDigits :: Integral a => [a] -> a
unDigits = foldl (\a b -> 10 * a + b) 0

------------------------- DISPLAY ------------------------
fTable ::
  String ->
  (a -> String) ->
  (b -> String) ->
  (a -> b) ->
  [a] ->
  String
fTable s xShow fxShow f xs =
  unlines $
    s :
    fmap
      ( ((<>) . rjust w ' ' . xShow)
          <*> ((" -> " <>) . fxShow . f)
      )
      xs
  where
    w = maximum (length . xShow <$> xs)

rjust :: Int -> Char -> String -> String
rjust n c = drop . length <*> (replicate n c <>)
