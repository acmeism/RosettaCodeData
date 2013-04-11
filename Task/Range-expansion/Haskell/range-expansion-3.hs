import Control.Monad
import Text.ParserCombinators.Parsec

expandRange :: String -> [Int]
expandRange s = case parse rangeParser "" s of Right l -> l

rangeParser :: Parser [Int]
rangeParser = liftM concat $ item `sepBy` char ','
  where item = do
            n1 <- num
            n2 <- option n1 $ char '-' >> num
            return [n1 .. n2]
        num :: Parser Int
        num = liftM read $ liftM2 (++)
            (option "" $ string "-")
            (many1 digit)
