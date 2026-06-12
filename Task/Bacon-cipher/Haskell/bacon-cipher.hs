-- Necessary imports
import Data.List (elemIndex, unfoldr)
import Data.Bool (bool)
import Data.Char (isAlpha, isUpper, toLower, toUpper)
import Data.List.Split (chunksOf)

-- The list of characters to be encoded:
chars :: String
chars = ['a' .. 'z'] ++ ['0' .. '9'] ++ ",.;?! "

bitsPerChar :: Int
bitsPerChar = 6

-- Some simple helper functions:
toBinary :: Int -> [Bool]
toBinary = unfoldr (pure . (\(a, b) -> (odd b, a)) . (`divMod` 2))

fromBinary :: [Bool] -> Int
fromBinary = foldr (\x n -> (2 * n) + bool 0 1 x) 0

-- And finally, main functions -- encoding:
encode :: String -> String -> Either String String
encode txt message = do
  mask <- traverse coding message
  zipAlphas (bool toLower toUpper) (concat mask) txt
  where
    coding ch =
      case elemIndex ch chars of
        Nothing -> Left $ "Unknown symbol " ++ show ch
        Just i -> Right $ take bitsPerChar (toBinary i)
    zipAlphas f = go
      where
        go _ [] = Left "Text is not long enough!"
        go [] _ = Right []
        go (x:xs) (y:ys)
          | isAlpha y = (f x y :) <$> go xs ys
          | otherwise = (y :) <$> go (x : xs) ys

-- And decoding:
decode :: String -> String
decode = map decipher . chunksOf bitsPerChar . filter isAlpha
  where
    decipher = (chars !!) . min (length chars - 1) . fromBinary . map isUpper
    chunksOf n = takeWhile (not . null) . unfoldr (pure . splitAt n)

-- Examples
text :: String
text =
  unwords
    [ "Bacon's cipher is a method of steganography created by Francis Bacon."
    , "This task is to implement a program for encryption and decryption of"
    , "plaintext using the simple alphabet of the Baconian cipher or some"
    , "other kind of representation of this alphabet (make anything signify"
    , "anything). The Baconian alphabet may optionally be extended to encode"
    , "all lower case characters individually and/or adding a few punctuation"
    , "characters such as the space."
    ]

message :: String
message = "the quick brown fox jumps over the lazy dog"

main :: IO ()
main = do
  let m = encode text message
  mapM_
    (either
       (putStrLn . ("-> " ++))
       (putStrLn . (++ "\n") . unlines . fmap unwords . chunksOf 10 . words))
    [ m
    , decode <$> m
    , encode text "something wrong @  in the message"
    , encode "abc" message
    ]
