module Digestor
   where
import Data.Digest.Pure.SHA
import qualified Data.ByteString.Lazy as B

convertString :: String -> B.ByteString
convertString phrase = B.pack $ map ( fromIntegral . fromEnum ) phrase

convertToSHA1 :: String -> String
convertToSHA1 word = showDigest $ sha1 $ convertString word

main = do
   putStr "Rosetta Code SHA1-codiert: "
   putStrLn $ convertToSHA1 "Rosetta Code"
