import qualified Data.ByteString.Base64 as Base64 (decode, encode)
import qualified Data.ByteString.Char8 as B (putStrLn, readFile)

main :: IO ()
main = B.readFile "favicon.ico" >>= (B.putStrLn . Base64.encode)
