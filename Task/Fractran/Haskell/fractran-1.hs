import Data.List (find)
import Data.Ratio (Ratio, (%), denominator)

fractran :: (Integral a) => [Ratio a] -> a -> [a]
fractran fracts n = n :
  case find (\f -> n `mod` denominator f == 0) fracts of
    Nothing -> []
    Just f -> fractran fracts $ truncate (fromIntegral n * f)
