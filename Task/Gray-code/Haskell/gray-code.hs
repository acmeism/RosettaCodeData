import Data.Bits
import Data.Char
import Numeric
import Control.Monad
import Text.Printf

grayToBin :: (Integral t, Bits t) => t -> t
grayToBin 0 = 0
grayToBin g = g `xor` (grayToBin $ g `shiftR` 1)

binToGray :: (Integral t, Bits t) => t -> t
binToGray b = b `xor` (b `shiftR` 1)

showBinary :: (Integral t, Show t) => t -> String
showBinary n = showIntAtBase 2 intToDigit n ""

showGrayCode :: (Integral t, Bits t, PrintfArg t, Show t) => t -> IO ()
showGrayCode num = do
    let bin  = showBinary num
    let gray = showBinary (binToGray num)
    printf "int: %2d -> bin: %5s -> gray: %5s\n" num bin gray

main = forM_ [0..31::Int] showGrayCode
