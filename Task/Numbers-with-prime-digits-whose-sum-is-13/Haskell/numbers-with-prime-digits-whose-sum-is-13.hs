import Data.List.Split (chunksOf)
import Data.List (intercalate, transpose, unfoldr)
import Text.Printf

primeDigitsNumsSummingToN :: Int -> [Int]
primeDigitsNumsSummingToN n = concat $ unfoldr go (return <$> primeDigits)
  where
    primeDigits = [2, 3, 5, 7]

    go :: [[Int]] -> Maybe ([Int], [[Int]])
    go xs
      | null xs = Nothing
      | otherwise = Just (nextLength xs)

    nextLength :: [[Int]] -> ([Int], [[Int]])
    nextLength xs =
      let harvest nv =
            [ unDigits $ fst nv
            | n == snd nv ]
          prune nv =
            [ fst nv
            | pred n > snd nv ]
      in ((,) . concatMap harvest <*> concatMap prune)
           (((,) <*> sum) <$> ((<$> xs) . (<>) . return =<< primeDigits))

--------------------------- TEST -------------------------
main :: IO ()
main = do
  let n = 13
      xs = primeDigitsNumsSummingToN n
  mapM_
    putStrLn
    [ concat
        [ (show . length) xs
        , " numbers with prime digits summing to "
        , show n
        , ":\n"
        ]
    , table " " $ chunksOf 10 (show <$> xs)
    ]

table :: String -> [[String]] -> String
table gap rows =
  let ic = intercalate
      ws = maximum . fmap length <$> transpose rows
      pw = printf . flip ic ["%", "s"] . show
  in unlines $ ic gap . zipWith pw ws <$> rows

unDigits :: [Int] -> Int
unDigits = foldl ((+) . (10 *)) 0
