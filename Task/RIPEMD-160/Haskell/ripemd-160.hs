import Data.Char (ord)
import Crypto.Hash.RIPEMD160 (hash)
import Data.ByteString (unpack, pack)
import Text.Printf (printf)

main = putStrLn $                     -- output to terminal
       concatMap (printf "%02x") $    -- to hex string
       unpack $                       -- to array of Word8
       hash $                         -- RIPEMD-160 hash to ByteString
       pack $                         -- to ByteString
       map (fromIntegral.ord)         -- to array of Word8
       "Rosetta Code"
