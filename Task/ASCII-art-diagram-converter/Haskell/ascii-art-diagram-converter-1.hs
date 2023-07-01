import Text.ParserCombinators.ReadP
import Control.Monad (guard)

data Field a = Field { fieldName :: String
                     , fieldSize :: Int
                     , fieldValue :: Maybe a}

instance Show a => Show (Field a) where
  show (Field n s a) = case a of
    Nothing -> n ++ "\t" ++ show s
    Just x -> n ++ "\t" ++ show s ++ "\t" ++ show x

newtype Data a = Data { fields :: [Field a] }

instance Show a => Show (Data a) where
  show (Data fs) = "NAME\tSIZE\tVALUE\n" ++ unlines (show <$> fs)

instance Read (Data a) where
  readsPrec _ = readP_to_S parseData

parseData = do n <- parseHeader
               guard (n `elem` [8,16,32,64]) -- check size of the table
               Data . concat <$> many1 (parseRow n)
  where
    parseRow n = do
      fs <- char '|' *> many parseField <* char '\n'
      guard $ sum (fieldSize <$> fs) == n -- check that size of all fields match the row size
      m <- parseHeader
      guard $ m == n -- check that all rows have the same size
      return fs

    parseHeader = do
      char '+'
      n <- length <$> many1 (string "--+")
      char '\n'
      return n

    parseField = do
      s1 <- many (char ' ')
      f <- munch1 $ not . (`elem` " |")
      s2 <- many (char ' ')
      char '|'
      let n = (length (s1 ++ f ++ s2) + 1) `div` 3
      return $ Field f n Nothing

-- emulation of reading a stream of bits
readData :: Data a -> [b] -> Data [b]
readData d = Data . go (fields d)
  where
    go fs [] = (\f -> f {fieldValue = Nothing}) <$> fs
    go (f:fs) s =
      let (x, xs) = splitAt (fieldSize f) s
      in f {fieldValue = Just x} : go fs xs


diagram = unlines
  ["+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+"
  ,"|                      ID                       |"
  ,"+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+"
  ,"|QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |"
  ,"+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+"
  ,"|                    QDCOUNT                    |"
  ,"+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+"
  ,"|                    ANCOUNT                    |"
  ,"+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+"
  ,"|                    NSCOUNT                    |"
  ,"+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+"
  ,"|                    ARCOUNT                    |"
  ,"+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+"]

dataSample = concat
  ["011110000100011101111011101111110101010010010110",
   "111000010010111000011011111100010110100110100100"]
