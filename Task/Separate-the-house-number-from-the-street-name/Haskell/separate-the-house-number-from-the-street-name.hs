{-# LANGUAGE OverloadedStrings #-}

{- Recommended package versions to use:
     base >= 4.7 && < 5
     regex-pcre-builtin >= 0.95 && < 0.96
     text >= 1.2.3 && < 1.3
-}

module Main where

import Control.Monad
import Data.Char
import Data.Monoid
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Text.Regex.PCRE.Text

testSet :: [T.Text]
testSet =
  [ "Plataanstraat 5"
  , "Straat 12"
  , "Straat 12 II"
  , "Dr. J. Straat   12"
  , "Dr. J. Straat 12 a"
  , "Dr. J. Straat 12-14"
  , "Laan 1940 – 1945 37"
  , "Plein 1940 2"
  , "1213-laan 11"
  , "16 april 1944 Pad 1"
  , "1e Kruisweg 36"
  , "Laan 1940-’45 66"
  , "Laan ’40-’45"
  , "Langeloërduinen 3 46"
  , "Marienwaerdt 2e Dreef 2"
  , "Provincialeweg N205 1"
  , "Rivium 2e Straat 59."
  , "Nieuwe gracht 20rd"
  , "Nieuwe gracht 20rd 2"
  , "Nieuwe gracht 20zw /2"
  , "Nieuwe gracht 20zw/3"
  , "Nieuwe gracht 20 zw/4"
  , "Bahnhofstr. 4"
  , "Wertstr. 10"
  , "Lindenhof 1"
  , "Nordesch 20"
  , "Weilstr. 6"
  , "Harthauer Weg 2"
  , "Mainaustr. 49"
  , "August-Horch-Str. 3"
  , "Marktplatz 31"
  , "Schmidener Weg 3"
  , "Karl-Weysser-Str. 6"
  ]

-- This is the regex from the Perl implementation of the task.
addressPattern :: T.Text
addressPattern = T.unlines
  [ "^ (.*?) \\s+"
  , "  ("
  , "     \\d* (\\-|\\/)? \\d*"
  , "   | \\d{1,3} [a-zI./ ]* \\d{0,3}"
  , "  )"
  , "$"
  ]

splitAddressASCII :: Regex -> T.Text -> IO (T.Text, T.Text)
splitAddressASCII rx txt = do
  result <- regexec rx txt
  case result of
    Left w -> fail (show w)
    Right (Just (_, _, _, (street:house:_))) -> return (street, house)
    _ -> return (txt, "")

-- For reasons I don't understand, PCRE isn't handling UTF-8 correctly,
-- even when the compUTF8 option is given.  So, hack around it by
-- assuming any non-ASCII characters are in the street name, not the number.
splitAddress :: Regex -> T.Text -> IO (T.Text, T.Text)
splitAddress rx txt = do
  let prefix = T.dropWhileEnd isAscii txt
      ascii = T.takeWhileEnd isAscii txt
  (street, house) <- splitAddressASCII rx ascii
  return (prefix <> street, house)

formatPairs :: [(T.Text, T.Text)] -> [T.Text]
formatPairs pairs =
  let headings = ("Street", "House Number")
      (streets, houses) = unzip (headings : pairs)
      sLen = maximum $ map T.length streets
      hLen = maximum $ map T.length houses
      sep = (T.replicate sLen "-", T.replicate hLen "-")
      fmt (s, h) = T.justifyLeft (sLen + 4) ' ' s <> h
  in map (T.strip . fmt) (headings : sep : pairs)

main :: IO ()
main = do
  erx <- compile (compExtended + compUTF8) execBlank addressPattern
  rx <- case erx of
          Left (offset, str) -> fail $ show offset ++ ": " ++ str
          Right r -> return r
  pairs <- mapM (splitAddress rx) testSet
  mapM_ T.putStrLn $ formatPairs pairs
