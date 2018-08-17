import Data.Functor
import Text.Parsec ((<|>), (<?>), many, many1, char, try, parse, sepBy, choice, between)
import Text.Parsec.Char (noneOf)
import Text.Parsec.Token (integer, float, whiteSpace, stringLiteral, makeTokenParser)
import Text.Parsec.Language (haskell)

data Val = Int Integer
         | Float Double
         | String String
         | Symbol String
         | List [Val] deriving (Eq, Show)

tProg = many tExpr <?> "program"
  where tExpr = between ws ws (tList <|> tAtom) <?> "expression"
        ws = whiteSpace haskell
        tAtom  =  (try (Float <$> float haskell) <?> "floating point number")
              <|> (try (Int <$> integer haskell) <?> "integer")
              <|> (String <$> stringLiteral haskell <?> "string")
              <|> (Symbol <$> many1 (noneOf "()\"\t\n\r ") <?> "symbol")
              <?> "atomic expression"
        tList = List <$> between (char '(') (char ')') (many tExpr) <?> "list"

p = either print (putStrLn . unwords . map show) . parse tProg ""

main = do
    let expr = "((data \"quoted data\" 123 4.5)\n  (data (!@# (4.5) \"(more\" \"data)\")))"
    putStrLn ("The input:\n" ++ expr ++ "\nParsed as:")
    p expr
