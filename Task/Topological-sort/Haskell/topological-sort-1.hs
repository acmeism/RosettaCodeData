import Data.List ((\\), elemIndex, intersect, nub)
import Data.Bifunctor (bimap, first)

combs 0 _ = [[]]
combs _ [] = []
combs k (x:xs) = ((x :) <$> combs (k - 1) xs) ++ combs k xs

depLibs :: [(String, String)]
depLibs =
  [ ( "des_system_lib"
    , "std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee")
  , ("dw01", "ieee dw01 dware gtech")
  , ("dw02", "ieee dw02 dware")
  , ("dw03", "std synopsys dware dw03 dw02 dw01 ieee gtech")
  , ("dw04", "dw04 ieee dw01 dware gtech")
  , ("dw05", "dw05 ieee dware")
  , ("dw06", "dw06 ieee dware")
  , ("dw07", "ieee dware")
  , ("dware", "ieee dware")
  , ("gtech", "ieee gtech")
  , ("ramlib", "std ieee")
  , ("std_cell_lib", "ieee std_cell_lib")
  , ("synopsys", [])
  ]

toposort :: [(String, String)] -> [String]
toposort xs
  | (not . null) cycleDetect =
    error $ "Dependency cycle detected for libs " ++ show cycleDetect
  | otherwise = foldl makePrecede [] dB
  where
    dB = (\(x, y) -> (x, y \\ x)) . bimap return words <$> xs
    makePrecede ts ([x], xs) =
      nub $
      case elemIndex x ts of
        Just i -> uncurry (++) $ first (++ xs) $ splitAt i ts
        _ -> ts ++ xs ++ [x]
    cycleDetect =
      filter ((> 1) . length) $
      (\[(a, as), (b, bs)] -> (a `intersect` bs) ++ (b `intersect` as)) <$>
      combs 2 dB

main :: IO ()
main = print $ toposort depLibs
