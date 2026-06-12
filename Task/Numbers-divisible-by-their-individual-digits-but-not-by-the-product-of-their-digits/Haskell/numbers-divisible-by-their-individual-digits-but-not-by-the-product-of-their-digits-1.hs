import Data.List.Split (chunksOf)
import Text.Printf

divisible :: Int -> Bool
divisible = divdgt <*> dgt
  where
    dgt = map (read . pure) . show
    divdgt x d =
      notElem 0 d
        && 0 /= x `mod` product d
        && all ((0 ==) . mod x) d

numbers :: [Int]
numbers = filter divisible [1 ..]

main :: IO ()
main = putStr $ unlines $ map (concatMap $ printf "%5d") split
  where
    n = takeWhile (< 1000) numbers
    split = chunksOf 10 n
