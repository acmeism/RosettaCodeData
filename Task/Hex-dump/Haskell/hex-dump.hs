-- ============================================================
-- Canonical Hexdump in Haskell
-- Demonstrates dumping UTF-16 little-endian encoded text
-- ============================================================

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import Data.Word (Word8)
import Data.Char (chr, isPrint)
import Data.List (intercalate)
import Numeric (showHex)

import qualified Data.Text as T
import qualified Data.Text.Encoding as TE


-- ============================================================
-- Configuration
-- ============================================================

-- Number of bytes displayed per line (classic hexdump uses 16)
bytesPerLine :: Int
bytesPerLine = 16


-- ============================================================
-- Public API
-- ============================================================

-- Dump the entire ByteString
hexdump :: B.ByteString -> String
hexdump bs = hexdumpSlice bs 0 (B.length bs)

-- Dump from a byte offset
hexdumpFrom :: B.ByteString -> Int -> String
hexdumpFrom bs off = hexdumpSlice bs off (B.length bs - off)

-- Dump a slice (offset + length)
hexdumpSlice :: B.ByteString -> Int -> Int -> String
hexdumpSlice bs off len =
    let sliced = B.take len (B.drop off bs)
        blocks = chunk bytesPerLine sliced
        lines' = zipWith formatLine [off, off + bytesPerLine ..] blocks
    in intercalate "\n" lines'


-- ============================================================
-- Chunking helper
-- ============================================================

-- Split a ByteString into fixed-size blocks
chunk :: Int -> B.ByteString -> [B.ByteString]
chunk n bs
    | B.null bs = []
    | otherwise =
        let (h, t) = B.splitAt n bs
        in h : chunk n t


-- ============================================================
-- Line formatting
-- ============================================================

formatLine :: Int -> B.ByteString -> String
formatLine offset block =
    padHex offset ++ "  " ++ hexColumn block ++ "  |" ++ asciiColumn block ++ "|"


-- Format offset as 8-digit hexadecimal
padHex :: Int -> String
padHex n =
    let h = showHex n ""
    in replicate (8 - length h) '0' ++ h


-- ============================================================
-- Hex column
-- ============================================================

hexColumn :: B.ByteString -> String
hexColumn block =
    let bytes    = B.unpack block
        hexBytes = map byteHex bytes

        -- Pad short final line with spaces
        padded = hexBytes ++ replicate (bytesPerLine - length hexBytes) "  "

        -- Split into two groups of 8 (classic layout)
        (l, r) = splitAt 8 padded
    in intercalate " " l ++ "  " ++ intercalate " " r


byteHex :: Word8 -> String
byteHex b =
    let h = showHex b ""
    in if length h == 1 then '0' : h else h


-- ============================================================
-- ASCII column
-- ============================================================

asciiColumn :: B.ByteString -> String
asciiColumn =
    map printable . B.unpack


printable :: Word8 -> Char
printable b =
    let c = chr (fromIntegral b)
    in if isPrint c then c else '.'


-- ============================================================
-- UTF-16 Little-Endian Example Builder
-- ============================================================

-- UTF-16 LE Byte Order Mark (BOM)
utf16LE_BOM :: B.ByteString
utf16LE_BOM = B.pack [0xFF, 0xFE]


-- Encode a Haskell String to UTF-16 little-endian bytes
encodeUTF16LE :: String -> B.ByteString
encodeUTF16LE s =
    TE.encodeUtf16LE (T.pack s)


-- Build full byte sequence with BOM + encoded text
utf16Example :: String -> B.ByteString
utf16Example s =
    utf16LE_BOM <> encodeUTF16LE s

-- ============================================================
-- Main test driver
-- ============================================================
main :: IO ()
main = do

    let message =
          "Rosetta Code is a programming chrestomathy site 😀."

    -- Encode into UTF-16 little-endian with BOM
    let bytes = utf16Example message

    putStrLn "UTF-16 Little-Endian Hexdump (with BOM):\n"
    putStrLn (hexdump bytes)
    putStrLn "\n--- Partial dump (offset 16, length 64) ---\n"
    putStrLn (hexdumpSlice bytes 16 64)

