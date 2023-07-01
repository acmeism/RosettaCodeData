import Data.Bits
import Numeric

zeckendorf = map b $ filter ones [0..] where
	ones :: Int -> Bool
	ones x = 0 == x .&. (x `shiftR` 1)
	b x = showIntAtBase 2 ("01"!!) x ""

main = mapM_ putStrLn $ take 21 zeckendorf
