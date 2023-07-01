import Data.List (intercalate, transpose, uncons, unfoldr)
import Data.List.Split (chunksOf)
import Data.Numbers.Primes (isPrime)
import Text.Printf (printf)

-------------------- JACOBSTHAL NUMBERS ------------------

jacobsthal :: [Integer]
jacobsthal = jacobsthalish (0, 1)

jacobsthalish :: (Integer, Integer) -> [Integer]
jacobsthalish = unfoldr go
  where
    go (a, b) = Just (a, (b, 2 * a + b))

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    (putStrLn . format)
    [ ( "terms of the Jacobsthal sequence",
        30,
        jacobsthal
      ),
      ( "Jacobsthal-Lucas numbers",
        30,
        jacobsthalish (2, 1)
      ),
      ( "Jacobsthal oblong numbers",
        20,
        zipWith (*) jacobsthal (tail jacobsthal)
      ),
      ( "Jacobsthal primes",
        10,
        filter isPrime jacobsthal
      )
    ]

format :: (String, Int, [Integer]) -> String
format (k, n, xs) =
  show n <> (' ' : k) <> ":\n"
    <> table
      "  "
      (chunksOf 5 $ show <$> take n xs)

table :: String -> [[String]] -> String
table gap rows =
  let ws = maximum . fmap length <$> transpose rows
      pw = printf . flip intercalate ["%", "s"] . show
   in unlines $ intercalate gap . zipWith pw ws <$> rows
