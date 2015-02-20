import Control.Applicative (Applicative((<*>),(*>)),(<$>))
import Text.Parsec

expandRange :: String -> Maybe [Int]
expandRange = either (const Nothing) Just . parse rangeParser ""

rangeParser :: Parser [Int]
rangeParser = concat <$> (item `sepBy` char ',')
  where item = do n1 <- num
                  n2 <- option n1 (char '-' *> num)
                  return [n1 .. n2]
        num :: Parser Int
        num = read `dot` (++) <$> option "" (string "-") <*> many1 digit
        dot = ((.).(.))
