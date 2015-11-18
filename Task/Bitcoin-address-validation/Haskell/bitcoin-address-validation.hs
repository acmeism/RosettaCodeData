import Data.List (unfoldr, elemIndex)
import Data.Binary (Word8)
import Crypto.Hash.SHA256 (hash)
import Data.ByteString (unpack, pack)

-- Convert from base58 encoded value to Integer
decode58 :: String -> Maybe Integer
decode58 = foldl (\v d -> (+) <$> ((58*) <$> v) <*> (fromIntegral <$> elemIndex d c58 )) $ Just 0
  where c58 = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

-- Convert from base58 encoded value to list of bytes
toBytes :: Integer -> [Word8]
toBytes x = reverse $ unfoldr (\b -> if b == 0 then Nothing else Just (fromIntegral $ b `mod` 256, b `div` 256)) x

-- Check validity of base58 encoded bitcoin address.
-- Result is either an error string (Left) or a validity bool (Right).
validityCheck :: String -> Either String Bool
validityCheck encodedAddress =
  let d58 = decode58 encodedAddress
  in case d58 of
       Nothing -> Left "Invalid base 58 encoding"
       Just ev ->
         let address = toBytes ev
             addressLength = length address
         in if addressLength > 24
            then Left "Address length exceeds 25 bytes"
            else
              if addressLength < 4
              then Left "Address length less than 4 bytes"
              else
                let (bs,cs) = splitAt 21 $ replicate (25 - addressLength) 0 ++ address
                in Right $ all (uncurry (==)) (zip cs $ unpack $ hash $ hash $ pack bs)

-- Run one validity check and display results.
validate :: String -> IO ()
validate encodedAddress =
  let vc = validityCheck encodedAddress
  in case vc of
       Left err ->
         putStrLn $ show encodedAddress ++ " -> " ++ show err
       Right validity ->
         putStrLn $ show encodedAddress ++ " -> " ++ if validity then "Valid" else "Invalid"

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
