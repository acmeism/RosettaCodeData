import Data.Set (fromList)
import Numeric (showHex)

lcmDigits :: Int
lcmDigits = foldr1 lcm [1 .. 15] -- 360360

upperLimit :: Int
upperLimit = allDigits - rem allDigits lcmDigits
  where
    allDigits = 0xfedcba987654321

main :: IO ()
main =
  (print . head)
    (filter ((15 ==) . length . fromList) $
     (`showHex` []) <$> [upperLimit,upperLimit - lcmDigits .. 1])
