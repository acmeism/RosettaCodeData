import Data.List (intercalate, transpose)
import Data.List.Split (chunksOf)
import qualified Data.Set as S
import Text.Printf (printf)

--------------------- SUNDARAM PRIMES --------------------

sundaram :: Integral a => a -> [a]
sundaram n =
  [ succ (2 * x)
    | x <- [1 .. m],
      x `S.notMember` excluded
  ]
  where
    m = div (pred n) 2
    excluded =
      S.fromList
        [ 2 * i * j + i + j
          | let fm = fromIntegral m,
            i <- [1 .. floor (sqrt (fm / 2))],
            let fi = fromIntegral i,
            j <- [i .. floor ((fm - fi) / succ (2 * fi))]
        ]

nSundaramPrimes ::
  (Integral a1, RealFrac a2, Floating a2) => a2 -> [a1]
nSundaramPrimes n =
  sundaram $ floor $ (2.4 * n * log n) / 2



--------------------------- TEST -------------------------
main :: IO ()
main = do
  putStrLn "First 100 Sundaram primes (starting at 3):\n"
  (putStrLn . table " " . chunksOf 10) $
    show <$> nSundaramPrimes 100

table :: String -> [[String]] -> String
table gap rows =
  let ws = maximum . fmap length <$> transpose rows
      pw = printf . flip intercalate ["%", "s"] . show
   in unlines $ intercalate gap . zipWith pw ws <$> rows
