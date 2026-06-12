-- | Base 64 Encoding.
-- A port, with slight variations, of the C version found here:
-- http://rosettacode.org/wiki/Base64#C (manual implementation)
--
-- ghc -Wall base64_encode.hs ; cat favicon.ico | ./base64_encode
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

module Main where

import Data.Bits
import Data.Char

import qualified Data.ByteString.Char8 as C

-- | alphaTable: Our base64 lookup table.
alphaTable :: C.ByteString
alphaTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

-- | b64Encode: Simple base64 encode function operating on normal C.ByteString's
b64Encode :: C.ByteString -> C.ByteString
b64Encode stream =
  if C.null stream
    then C.empty
    else alphaTable `C.index` shiftR _u 18 `C.cons` alphaTable `C.index`
         (shiftR _u 12 .&. 63) `C.cons`
         (if C.length chunk < 2
            then '='
            else alphaTable `C.index` (shiftR _u 6 .&. 63)) `C.cons`
         (if C.length chunk < 3
            then '='
            else alphaTable `C.index` (_u .&. 63)) `C.cons`
         b64Encode (C.drop 3 stream)
  where
    chunk = C.take 3 stream
    _u = u chunk

-- | b64EncodePretty: Intersperses \n every 76 bytes for prettier output
b64EncodePretty :: C.ByteString -> C.ByteString
b64EncodePretty = makePretty 76 . b64Encode

-- | u: base64 encoding magic
u :: C.ByteString -> Int
u chunk = fromIntegral result :: Int
  where
    result =
      foldl (.|.) 0 $
      zipWith
        shiftL
        (C.foldr (\c acc -> charToInteger c : acc) [] chunk)
        [16, 8, 0]

-- lazy foldl to fix formatting
-- | charToInteger: Convert a Char to an Integer
charToInteger :: Char -> Integer
charToInteger c = fromIntegral (ord c) :: Integer

-- | makePretty: Add new line characters throughout a character stream
makePretty :: Int -> C.ByteString -> C.ByteString
makePretty _ (C.uncons -> Nothing) = C.empty
makePretty by stream = first `C.append` "\n" `C.append` makePretty by rest
  where
    (first, rest) = C.splitAt by stream

main :: IO ()
main = C.getContents >>= C.putStr . b64EncodePretty
