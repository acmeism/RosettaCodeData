import Data.List (group)

-- Datatypes
type Encoded = [(Int, Char)] -- An encoded String with form [(times, char), ...]

type Decoded = String

-- Takes a decoded string and returns an encoded list of tuples
rlencode :: Decoded -> Encoded
rlencode = fmap ((,) <$> length <*> head) . group

-- Takes an encoded list of tuples and returns the associated decoded String
rldecode :: Encoded -> Decoded
rldecode = concatMap (uncurry replicate)

main :: IO ()
main = do
  let input = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
      -- Output encoded and decoded versions of input
      encoded = rlencode input
      decoded = rldecode encoded
  putStrLn $ "Encoded: " <> show encoded <> "\nDecoded: " <> show decoded
