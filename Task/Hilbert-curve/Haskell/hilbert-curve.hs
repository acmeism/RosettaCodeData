import Data.Tree (Tree (..))

---------------------- HILBERT CURVE ---------------------

hilbertTree :: Int -> Tree Char
hilbertTree n
  | 0 < n = iterate go seed !! pred n
  | otherwise = seed
  where
    seed = Node 'a' []
    go tree
      | null xs = Node c (flip Node [] <$> rule c)
      | otherwise = Node c (go <$> xs)
      where
        c = rootLabel tree
        xs = subForest tree


hilbertPoints :: Int -> Tree Char -> [(Int, Int)]
hilbertPoints w = go r (r, r)
  where
    r = quot w 2
    go r xy tree
      | null xs = centres
      | otherwise = concat $ zipWith (go d) centres xs
      where
        d = quot r 2
        f g x = g xy + (d * g x)
        centres =
          ((,) . f fst)
            <*> f snd <$> vectors (rootLabel tree)
        xs = subForest tree


--------------------- PRODUCTION RULE --------------------

rule :: Char -> String
rule c =
  case c of
    'a' -> "daab"
    'b' -> "cbba"
    'c' -> "bccd"
    'd' -> "addc"
    _ -> []

vectors :: Char -> [(Int, Int)]
vectors c =
  case c of
    'a' -> [(-1, 1), (-1, -1), (1, -1), (1, 1)]
    'b' -> [(1, -1), (-1, -1), (-1, 1), (1, 1)]
    'c' -> [(1, -1), (1, 1), (-1, 1), (-1, -1)]
    'd' -> [(-1, 1), (1, 1), (1, -1), (-1, -1)]
    _ -> []


--------------------------- TEST -------------------------

main :: IO ()
main = do
  let w = 1024
  putStrLn $ svgFromPoints w $ hilbertPoints w (hilbertTree 6)

svgFromPoints :: Int -> [(Int, Int)] -> String
svgFromPoints w xys =
  let sw = show w
      points =
        (unwords . fmap (((<>) . show . fst) <*> ((' ' :) . show . snd))) xys
   in unlines
        [ "<svg xmlns=\"http://www.w3.org/2000/svg\"",
          unwords
            ["width=\"512\" height=\"512\" viewBox=\"5 5", sw, sw, "\"> "],
          "<path d=\"M" ++ points ++ "\" ",
          "stroke-width=\"2\" stroke=\"red\" fill=\"transparent\"/>",
          "</svg>"
        ]
