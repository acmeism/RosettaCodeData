import Data.List (intercalate, maximumBy, sort)
import Data.Ord (comparing)

------------------- RANGE CONSOLIDATION ------------------

consolidated :: [(Float, Float)] -> [(Float, Float)]
consolidated = foldr go [] . sort . fmap ab
  where
    go xy [] = [xy]
    go xy@(x, y) abetc@((a, b) : etc)
      | y >= b = xy : etc
      | y >= a = (x, b) : etc
      | otherwise = xy : abetc
    ab (a, b)
      | a <= b = (a, b)
      | otherwise = (b, a)


--------------------------- TEST -------------------------
tests :: [[(Float, Float)]]
tests =
  [ [],
    [(1.1, 2.2)],
    [(6.1, 7.2), (7.2, 8.3)],
    [(4, 3), (2, 1)],
    [(4, 3), (2, 1), (-1, -2), (3.9, 10)],
    [(1, 3), (-6, -1), (-4, -5), (8, 2), (-6, -6)]
  ]

main :: IO ()
main =
  putStrLn $
    tabulated
      "Range consolidations:"
      showPairs
      showPairs
      consolidated
      tests

-------------------- DISPLAY FORMATTING ------------------

tabulated ::
  String ->
  (a -> String) ->
  (b -> String) ->
  (a -> b) ->
  [a] ->
  String
tabulated s xShow fxShow f xs =
  let w =
        length $
          maximumBy
            (comparing length)
            (xShow <$> xs)
      rjust n c s = drop (length s) (replicate n c <> s)
   in unlines $
        s :
        fmap
          ( ((<>) . rjust w ' ' . xShow)
              <*> ((" -> " <>) . fxShow . f)
          )
          xs

showPairs :: [(Float, Float)] -> String
showPairs xs
  | null xs = "[]"
  | otherwise =
    '[' :
    intercalate
      ", "
      (showPair <$> xs)
      <> "]"

showPair :: (Float, Float) -> String
showPair (a, b) =
  '(' :
  showNum a
    <> ", "
    <> showNum b
    <> ")"

showNum :: Float -> String
showNum n
  | 0 == (n - fromIntegral (round n)) = show (round n)
  | otherwise = show n
