import Data.List (group)
import Control.Arrow ((&&&))

-- Datatypes
type Encoded = [(Int, Char)]  -- An encoded String with form [(times, char), ...]
type Decoded = String

-- Takes a decoded string and returns an encoded list of tuples
rlencode :: Decoded -> Encoded
rlencode = map (length &&& head) . group

-- Takes an encoded list of tuples and returns the associated decoded String
rldecode :: Encoded -> Decoded
rldecode = concatMap (uncurry replicate)

main :: IO ()
main = do
  -- Get input
  putStr "String to encode: "
  input <- getLine
  -- Output encoded and decoded versions of input
  let encoded = rlencode input
      decoded = rldecode encoded
  putStrLn $ "Encoded: " ++ show encoded ++ "\nDecoded: " ++ show decoded
