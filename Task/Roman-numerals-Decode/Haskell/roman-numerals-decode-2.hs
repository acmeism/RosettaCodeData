import Data.List (mapAccumL, isPrefixOf)

romanValue :: String -> Int
romanValue s = sum . snd $ mapAccumL tr s
    [("M", 1000), ("CM", 900), ("D", 500), ("CD", 400),
     ("C",  100), ("XC",  90) ,("L",  50), ("XL",  40),
     ("X",   10), ("IX",   9), ("V",   5), ("IV",   4),
     ("I",    1)]
  where
    tr s (k, v) =
        until (\(s, _) -> not $ isPrefixOf k s)
              (\(s, n) -> (drop (length k) s, n + v)) (s, 0)

main :: IO ()
main = mapM_ (putStrLn . show . romanValue)
    ["MDCLXVI", "MCMXC", "MMVIII", "MMXVI", "MMXVII"]
