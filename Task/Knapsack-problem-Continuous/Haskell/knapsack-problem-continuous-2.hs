import Data.List (sortBy)
import Data.Ord (comparing)
import Text.Printf (printf)

-- (name, (value, weight))
items =
  [ ("beef", (36, 3.8))
  , ("pork", (43, 5.4))
  , ("ham", (90, 3.6))
  , ("greaves", (45, 2.4))
  , ("flitch", (30, 4.0))
  , ("brawn", (56, 2.5))
  , ("welt", (67, 3.7))
  , ("salami", (95, 3.0))
  , ("sausage", (98, 5.9))
  ]

unitWeight (_, (val, weight)) = fromIntegral val / weight

solution k = loop k . sortBy (flip $ comparing unitWeight)
  where
    loop k ((name, (_, weight)):xs)
      | weight < k = putStrLn ("Take all the " ++ name) >> loop (k - weight) xs
      | otherwise = printf "Take %.2f kg of the %s\n" (k :: Float) name

main = solution 15 items
