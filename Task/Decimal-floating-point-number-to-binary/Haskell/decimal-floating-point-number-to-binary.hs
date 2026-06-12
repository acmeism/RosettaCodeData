import Data.Char (intToDigit)
import Numeric (floatToDigits, showIntAtBase)

dec2bin :: RealFloat a => a -> String
dec2bin f = "0." ++ map intToDigit digits ++ "p+" ++ showIntAtBase 2 intToDigit ex ""
  where (digits, ex) = floatToDigits 2 f

main :: IO ()
main = putStrLn $ dec2bin 23.34375
