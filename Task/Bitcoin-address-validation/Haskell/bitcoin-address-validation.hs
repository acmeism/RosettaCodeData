import           Control.Monad      (when)
import           Data.List          (elemIndex)
import           Data.Monoid        ((<>))
import qualified Data.ByteString    as BS
import           Data.ByteString    (ByteString)

import           Crypto.Hash.SHA256 (hash)  -- from package cryptohash

-- Convert from base58 encoded value to Integer
decode58 :: String -> Maybe Integer
decode58 = fmap combine . traverse parseDigit
  where
    combine = foldl (\acc digit -> 58 * acc + digit) 0  -- should be foldl', but this trips up the highlighting
    parseDigit char = toInteger <$> elemIndex char c58
    c58 = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

-- Convert from base58 encoded value to bytes
toBytes :: Integer -> ByteString
toBytes = BS.reverse . BS.pack . map (fromIntegral . (`mod` 256)) . takeWhile (> 0) . iterate (`div` 256)

-- Check if the hash of the first 21 (padded) bytes matches the last 4 bytes
checksumValid :: ByteString -> Bool
checksumValid address =
  let (value, checksum) = BS.splitAt 21 $ leftPad address
  in and $ BS.zipWith (==) checksum $ hash $ hash $ value
  where
    leftPad bs = BS.replicate (25 - BS.length bs) 0 <> bs

-- utility
withError :: e -> Maybe a -> Either e a
withError e = maybe (Left e) Right

-- Check validity of base58 encoded bitcoin address.
-- Result is either an error string (Left) or unit (Right ()).
validityCheck :: String -> Either String ()
validityCheck encoded = do
  num <- withError "Invalid base 58 encoding" $ decode58 encoded
  let address = toBytes num
  when (BS.length address > 25) $ Left "Address length exceeds 25 bytes"
  when (BS.length address <  4) $ Left "Address length less than 4 bytes"
  when (not $ checksumValid address) $ Left "Invalid checksum"

-- Run one validity check and display results.
validate :: String -> IO ()
validate encodedAddress = do
  let result = either show (const "Valid") $ validityCheck encodedAddress
  putStrLn $ show encodedAddress ++ " -> " ++ result

-- Run some validity check tests.
main :: IO ()
main  = do
  validate "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i"     -- VALID
  validate "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9"     -- VALID
  validate "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X"     -- checksum changed, original data.
  validate "1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i"     -- data changed, original checksum.
  validate "1A Na15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i"     -- invalid chars
  validate "1ANa55215ZQXAZUgFiqJ2i7Z2DPU2J6hW62i"   -- too long
  validate "i55j"                                   -- too short
