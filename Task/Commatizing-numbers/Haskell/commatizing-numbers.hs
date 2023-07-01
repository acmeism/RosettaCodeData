#!/usr/bin/env runhaskell

import Control.Monad (forM_)
import Data.Char (isDigit)
import Data.List (intercalate)
import Data.Maybe (fromMaybe)

{-
I use the suffix "2" in identifiers in place of the more conventional
prime (single quote character), because Rosetta Code's syntax highlighter
still doesn't handle primes in identifiers correctly.
-}

isDigitOrPeriod :: Char -> Bool
isDigitOrPeriod '.' = True
isDigitOrPeriod c = isDigit c

chopUp :: Int -> String -> [String]
chopUp _ [] = []
chopUp by str
  | by < 1 = [str]              -- invalid argument, leave string unchanged
  | otherwise = let (pfx, sfx) = splitAt by str
                in pfx : chopUp by sfx

addSeps :: String -> Char -> Int -> (String -> String) -> String
addSeps str sep by rev =
  let (leading, number) = span (== '0') str
      number2 = rev $ intercalate [sep] $ chopUp by $ rev number
  in leading ++ number2

processNumber :: String -> Char -> Int -> String
processNumber str sep by =
  let (beforeDecimal, rest) = span isDigit str
      (decimal, afterDecimal) = splitAt 1 rest
      beforeDecimal2 = addSeps beforeDecimal sep by reverse
      afterDecimal2 = addSeps afterDecimal sep by id
  in beforeDecimal2 ++ decimal ++ afterDecimal2

commatize2 :: String -> Char -> Int -> String
commatize2 [] _ _ = []
commatize2 str sep by =
  let (pfx, sfx) = break isDigitOrPeriod str
      (number, sfx2) = span isDigitOrPeriod sfx
  in pfx ++ processNumber number sep by ++ sfx2

commatize :: String -> Maybe Char -> Maybe Int -> String
commatize str sep by = commatize2 str (fromMaybe ',' sep) (fromMaybe 3 by)

input :: [(String, Maybe Char, Maybe Int)]
input =
  [ ("pi=3.14159265358979323846264338327950288419716939937510582097494459231", Just ' ', Just 5)
  , ("The author has two Z$100000000000000 Zimbabwe notes (100 trillion).", Just '.', Nothing)
  , ("\"-in Aus$+1411.8millions\"", Nothing, Nothing)
  , ("===US$0017440 millions=== (in 2000 dollars)", Nothing, Nothing)
  , ("123.e8000 is pretty big.", Nothing, Nothing)
  , ("The land area of the earth is 57268900(29% of the surface) square miles.", Nothing, Nothing)
  , ("Ain't no numbers in this here words, nohow, no way, Jose.", Nothing, Nothing)
  , ("James was never known as 0000000007", Nothing, Nothing)
  , ("Arthur Eddington wrote: I believe there are 15747724136275002577605653961181555468044717914527116709366231425076185631031296 protons in the universe.", Nothing, Nothing)
  , ("   $-140000±100 millions.", Nothing, Nothing)
  , ("6/9/1946 was a good year for some.", Nothing, Nothing)
  ]

main :: IO ()
main =
  forM_ input $ \(str, by, sep) -> do
    putStrLn str
    putStrLn $ commatize str by sep
    putStrLn ""
