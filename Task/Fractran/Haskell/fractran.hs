import Data.List (find)
import Data.Ratio (Ratio, (%), denominator)

fractran :: (Integral a) => [Ratio a] -> a -> [a]
fractran fracts n = n :
  case find (\f -> n `mod` denominator f == 0) fracts of
    Nothing -> []
    Just f -> fractran fracts $ truncate (fromIntegral n * f)

main :: IO ()
main = print $ take 15 $ fractran [17%91, 78%85, 19%51, 23%38, 29%33, 77%29,
         95%23, 77%19, 1%17, 11%13, 13%11, 15%14, 15%2, 55%1] 2
