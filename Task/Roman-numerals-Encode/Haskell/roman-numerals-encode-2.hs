import Data.List (mapAccumL)

roman :: [(Int, String)] -> Int -> String
roman vks n =
  concat . snd $
  mapAccumL
    (\a (m, s) ->
        let (q, r) = quotRem a m
        in (r, [1 .. q] >> s))
    n
    vks

romanFromInt :: Int -> String
romanFromInt =
  roman $
  zip
    [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]

main :: IO ()
main = (putStrLn . unlines) (romanFromInt <$> [1666, 1990, 2008, 2016, 2018])
