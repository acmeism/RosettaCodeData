{-# LANGUAGE FlexibleContexts #-}

import Text.Parsec

expandRange :: String -> Maybe [Int]
expandRange =
  either
    (const Nothing)
    Just
    . parse rangeParser ""

rangeParser ::
  (Enum a, Read a, Stream s m Char) =>
  ParsecT s u m [a]
rangeParser = concat <$> (item `sepBy` char ',')
  where
    item = do
      n1 <- num
      n2 <- option n1 (char '-' *> num)
      return [n1 .. n2]
    num =
      read `dot` (<>) <$> option "" (string "-")
        <*> many1 digit
    dot = (.) . (.)

main :: IO ()
main = print $ expandRange "-6,-3--1,3-5,7-11,14,15,17-20"
