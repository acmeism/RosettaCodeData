import Data.Char
import Data.Map

charToInt :: Char -> Int
charToInt c = ord c - ord '0'

-- Given a string, decode a single character from the string.
-- Return the decoded char and the remaining undecoded string.
decodeChar :: String -> (Char,String)
decodeChar ('7':'9':r:rs) = (r,rs)
decodeChar ('7':r:rs)     = ("PQUVWXYZ. " !! charToInt r, rs)
decodeChar ('3':r:rs)     = ("ABCDFGIJKN" !! charToInt r, rs)
decodeChar (r:rs)         = ("HOL MES RT" !! charToInt r, rs)

-- Decode an entire string.
decode :: String -> String
decode [] = []
decode st = let (c, s) = decodeChar st in c:decode s

-- Given a string, decode a single character from the string.
-- Return the decoded char and the part of the encoded string
-- used to encode that character.
revEnc :: String -> (Char, String)
revEnc enc = let (dec, rm) = decodeChar enc in (dec, take (length enc - length rm) enc)

ds :: String
ds = ['0'..'9']

-- Decode all 1000 possible encodings of three digits and
-- use results to construct map used to encode.
encodeMap :: Map Char String
encodeMap = fromList [ revEnc [d2,d1,d0] | d2 <- ds, d1 <- ds, d0 <- ds ]

-- Encode a single char using encoding map.
encodeChar :: Char -> String
encodeChar c = findWithDefault "" c encodeMap

-- Encode an entire string.
encode :: String -> String
encode st = concatMap encodeChar $ fmap toUpper st

-- Test by encoding, decoding, printing results.
main = let orig = "One night-it was on the twentieth of March, 1888-I was returning"
           enc = encode orig
           dec = decode enc
       in mapM_ putStrLn [ "Original: " ++ orig
                         , "Encoded: " ++ enc
                         , "Decoded: " ++ dec ]
