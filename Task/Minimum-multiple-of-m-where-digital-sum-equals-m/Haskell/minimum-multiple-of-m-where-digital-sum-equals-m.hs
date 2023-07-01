import Data.Bifunctor (first)
import Data.List (elemIndex, intercalate, transpose)
import Data.List.Split (chunksOf)
import Data.Maybe (fromJust)
import Text.Printf (printf)

------------------------- A131382 ------------------------

a131382 :: [Int]
a131382 =
  fromJust . (elemIndex <*> productDigitSums)
    <$> [1 ..]

productDigitSums :: Int -> [Int]
productDigitSums n = digitSum . (n *) <$> [0 ..]

--------------------------- TEST -------------------------
main :: IO ()
main =
  (putStrLn . table " ") $
    chunksOf 10 $ show <$> take 40 a131382

------------------------- GENERIC ------------------------
digitSum :: Int -> Int
digitSum 0 = 0
digitSum n = uncurry (+) (first digitSum $ quotRem n 10)

table :: String -> [[String]] -> String
table gap rows =
  let ws = maximum . fmap length <$> transpose rows
      pw = printf . flip intercalate ["%", "s"] . show
   in unlines $ intercalate gap . zipWith pw ws <$> rows
