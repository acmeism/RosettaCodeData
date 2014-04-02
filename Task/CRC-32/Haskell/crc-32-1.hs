import Data.Bits
import Data.Word
import Numeric

crcTable :: Word32 -> Word32
crcTable i = table !! (fromIntegral i)
        where
                table = map (\a -> iterate xf a !! 8) [0..255]
                xf r = let d = shiftR r 1 in
                        if r .&. 1 == 1 then xor d 0xedb88320 else d

charToWord :: Char -> Word32
charToWord c = (fromIntegral . fromEnum) c

calcCrc :: String -> Word32
calcCrc text = complement ( foldl cf (complement 0) text )
        where cf crc x = xor (shiftR crc 8) (crcTable $ xor (crc .&. 0xff) (charToWord x) )

crc32 text = showHex ( calcCrc text ) ""

main = putStrLn $ crc32 "The quick brown fox jumps over the lazy dog"
