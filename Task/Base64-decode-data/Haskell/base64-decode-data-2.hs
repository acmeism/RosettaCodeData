{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString.Base64 as Base64 (decode, encode)
import qualified Data.ByteString.Char8 as B (putStrLn)

main :: IO ()
main = do
  B.putStrLn $
    Base64.encode
      "To err is human, but to really foul things up you need a computer.\n-- Paul R. Ehrlich"
  B.putStrLn "\n-->\n"
  either print B.putStrLn $
    Base64.decode
      "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCi0tIFBhdWwgUi4gRWhybGljaA=="
