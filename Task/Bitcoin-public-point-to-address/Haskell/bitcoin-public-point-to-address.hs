import Numeric (showIntAtBase)
import Data.List (unfoldr)
import Data.Binary (Word8)
import Crypto.Hash.SHA256 as S (hash)
import Crypto.Hash.RIPEMD160 as R (hash)
import Data.ByteString (unpack, pack)

publicPointToAddress :: Integer -> Integer -> String
publicPointToAddress x y =
  let toBytes x = reverse $ unfoldr (\b -> if b == 0 then Nothing else Just (fromIntegral $ b `mod` 256, b `div` 256)) x
      ripe = 0 : unpack (R.hash $ S.hash $ pack $ 4 : toBytes x ++ toBytes y)
      ripe_checksum = take 4 $ unpack $ S.hash $ S.hash $ pack ripe
      addressAsList = ripe ++ ripe_checksum
      address = foldl (\v b -> v * 256 + fromIntegral b) 0 addressAsList
      base58Digits = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
  in showIntAtBase 58 (base58Digits !!) address ""

main = print $ publicPointToAddress
  0x50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352
  0x2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6
