import Data.List (intercalate, unfoldr)
import Data.List.Split (chunksOf)

--------------------- LEONARDO NUMBERS ---------------------
-- L0 -> L1 -> Add number -> Series (infinite)
leo :: Integer -> Integer -> Integer -> [Integer]
leo l0 l1 d = unfoldr (\(x, y) -> Just (x, (y, x + y + d))) (l0, l1)

leonardo :: [Integer]
leonardo = leo 1 1 1

fibonacci :: [Integer]
fibonacci = leo 0 1 0

--------------------------- TEST ---------------------------
main :: IO ()
main =
  (putStrLn . unlines)
    [ "First 25 default (1, 1, 1) Leonardo numbers:\n"
    , f $ take 25 leonardo
    , "First 25 of the (0, 1, 0) Leonardo numbers (= Fibonacci numbers):\n"
    , f $ take 25 fibonacci
    ]
  where
    f = unlines . fmap (('\t' :) . intercalate ",") . chunksOf 16 . fmap show
