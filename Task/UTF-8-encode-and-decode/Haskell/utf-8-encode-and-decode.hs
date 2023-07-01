module Main (main) where

import qualified Data.ByteString as ByteString (pack, unpack)
import           Data.Char (chr, ord)
import           Data.Foldable (for_)
import           Data.List (intercalate)
import qualified Data.Text as Text (head, singleton)
import qualified Data.Text.Encoding as Text (decodeUtf8, encodeUtf8)
import           Text.Printf (printf)

encodeCodepoint :: Int -> [Int]
encodeCodepoint = map fromIntegral . ByteString.unpack . Text.encodeUtf8 . Text.singleton . chr

decodeToCodepoint :: [Int] -> Int
decodeToCodepoint = ord . Text.head . Text.decodeUtf8 . ByteString.pack . map fromIntegral

main :: IO ()
main = do
    putStrLn "Character  Unicode  UTF-8 encoding (hex)  Decoded"
    putStrLn "-------------------------------------------------"
    for_ [0x0041, 0x00F6, 0x0416, 0x20AC, 0x1D11E] $ \codepoint -> do
        let values = encodeCodepoint codepoint
            codepoint' = decodeToCodepoint values
        putStrLn $ printf "%c          %-7s  %-20s  %c"
            codepoint
            (printf "U+%04X" codepoint :: String)
            (intercalate " " (map (printf "%02X") values))
            codepoint'
