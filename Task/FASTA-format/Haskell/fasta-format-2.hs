import Text.ParserCombinators.ReadP
import Control.Applicative ( (<|>) )
import Data.Char ( isAlpha, isAlphaNum )

parseFasta :: FilePath -> IO ()
parseFasta fileName = do
  file <- readFile fileName
  let pairs = fst . last . readP_to_S readFasta $ file
  mapM_ (\(name, code) -> putStrLn $ name ++ ": " ++ code) pairs


readFasta :: ReadP [(String, String)]
readFasta = many pair <* eof
 where
  pair    = (,) <$> name <*> code
  name    = char '>' *> many (satisfy isAlphaNum <|> char '_') <* newline
  code    = concat <$> many (many (satisfy isAlpha) <* newline)
  newline = char '\n'
