import Data.List (intercalate, intersperse)
import Data.List.Split (chunksOf)
import System.Environment (getArgs)

-- An n by n square of characters, having 1s on the borders and 0s in the
-- interior.  We assume n ≥ 0.
square :: Int -> String
square n = intercalate "\n" $ map (intersperse ' ') $ chunksOf n sq
  where sq = [sqChar r c | r <- [0..n-1], c <- [0..n-1]]
        sqChar r c = if isBorder r c then '1' else '0'
        isBorder r c = r == 0 || r == n-1 || c == 0 || c == n-1

main :: IO ()
main = do
  sizes <- map read <$> getArgs
  putStrLn $ intercalate "\n\n" $ map square sizes
