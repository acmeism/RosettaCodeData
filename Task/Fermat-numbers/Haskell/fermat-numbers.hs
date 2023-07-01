import Data.Numbers.Primes (primeFactors)
import Data.Bool (bool)

fermat :: Integer -> Integer
fermat = succ . (2 ^) . (2 ^)

fermats :: [Integer]
fermats = fermat <$> [0 ..]

--------------------------- TEST ---------------------------
main :: IO ()
main =
  mapM_
    putStrLn
    [ fTable "First 10 Fermats:" show show fermat [0 .. 9]
    , fTable
        "Factors of first 7:"
        show
        showFactors
        primeFactors
        (take 7 fermats)
    ]

------------------------- DISPLAY --------------------------
fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  unlines $
  s : fmap (((++) . rjust w ' ' . xShow) <*> ((" -> " ++) . fxShow . f)) xs
  where
    rjust n c = drop . length <*> (replicate n c ++)
    w = maximum (length . xShow <$> xs)

showFactors :: [Integer] -> String
showFactors x
  | 1 < length x = show x
  | otherwise = "(prime)"
