--Decodes Base64 to ASCII
import qualified Data.Map.Strict as Map (Map, lookup, fromList)
import Data.Maybe (fromJust, listToMaybe, mapMaybe)
import Numeric (readInt, showIntAtBase)
import Data.Char (chr, digitToInt)
import Data.List.Split (chunksOf)

byteToASCII :: String -> String
byteToASCII = map chr . decoder

--generates list of bytes (represented by Int)
decoder :: String -> [Int]
decoder =
  map readBin .
  takeWhile (\x -> length x == 8) .
  chunksOf 8 . concatMap toBin . mapMaybe (`Map.lookup` table) . filter (/= '=')

--turns decimal into a list of char that represents a binary number
toBin :: Int -> String
toBin n = leftPad $ showIntAtBase 2 ("01" !!) n ""

--this adds all the zeros to the left that showIntAtBase omitted
leftPad :: String -> String
leftPad a = replicate (6 - length a) '0' ++ a

--turns list of '0' and '1' into list of 0 and 1
readBin :: String -> Int
readBin = fromJust . fmap fst . listToMaybe . readInt 2 (`elem` "01") digitToInt

--lookup list for the sextets
table :: Map.Map Char Int
table =
  Map.fromList $
  zip "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" [0 ..]

main :: IO ()
main =
  putStrLn $
  byteToASCII
    "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCi0tIFBhdWwgUi4gRWhybGljaA=="
