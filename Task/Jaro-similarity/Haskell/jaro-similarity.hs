import Data.List (elemIndex, intercalate, sortOn)
import Data.Maybe (mapMaybe)
import Text.Printf (printf)

---------------------- JARO DISTANCE ---------------------

jaro :: Ord a => [a] -> [a] -> Float
jaro x y
  | 0 == m = 0
  | otherwise =
    (1 / 3)
      * ( (m / s1) + (m / s2) + ((m - t) / m))
  where
    f = fromIntegral . length
    [m, t] =
      [f, fromIntegral . transpositions]
        <*> [matches x y]
    [s1, s2] = [f] <*> [x, y]

matches :: Eq a => [a] -> [a] -> [(Int, a)]
matches s1 s2 =
  let [(l1, xs), (l2, ys)] =
        sortOn
          fst
          ((length >>= (,)) <$> [s1, s2])
      r = quot l2 2 - 1
   in mapMaybe
        ( \(c, n) ->
            -- Initial chars out of range ?

            let offset = max 0 (n - (r + 1))
             in -- Any offset for this char within range.
                elemIndex c (drop offset (take (n + r) ys))
                  >>= (\i -> Just (offset + i, c))
        )
        (zip xs [1 ..])

transpositions :: Ord a => [(Int, a)] -> Int
transpositions =
  length
    . filter (uncurry (>))
    . (zip <*> tail)

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ putStrLn $
    fmap
      ( \(s1, s2) ->
          intercalate
            " -> "
            [s1, s2, printf "%.3f\n" $ jaro s1 s2]
      )
      [ ("DWAYNE", "DUANE"),
        ("MARTHA", "MARHTA"),
        ("DIXON", "DICKSONX"),
        ("JELLYFISH", "SMELLYFISH")
      ]
