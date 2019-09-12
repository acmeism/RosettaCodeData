import Data.Bits ((.&.), complement, shiftR, xor)
import Data.Word (Word32)
import Numeric (showHex)

crcTable :: Word32 -> Word32
crcTable = (table !!) . fromIntegral
  where
    table = ((!! 8) . iterate xf) <$> [0 .. 255]
    shifted x = shiftR x 1
    xf r
      | r .&. 1 == 1 = xor (shifted r) 0xedb88320
      | otherwise = shifted r

charToWord :: Char -> Word32
charToWord = fromIntegral . fromEnum

calcCrc :: String -> Word32
calcCrc = complement . foldl cf (complement 0)
  where
    cf crc x = xor (shiftR crc 8) (crcTable $ xor (crc .&. 0xff) (charToWord x))

crc32 :: String -> String
crc32 = flip showHex [] . calcCrc

main :: IO ()
main = putStrLn $ crc32 "The quick brown fox jumps over the lazy dog"
