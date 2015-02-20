import Data.ByteString
import Data.Bits

main = Data.ByteString.writeFile "out.pgm" (pack (fmap (fromIntegral . fromEnum) "P5\n256 256\n256\n" ++ [x `xor` y | x <- [0..255], y <- [0..255]]))
