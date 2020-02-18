import qualified Data.Functor.Identity as F
import qualified Text.Parsec.Prim as Prim
import Text.Parsec
       ((<|>), (<?>), many, many1, char, try, parse, sepBy, choice,
        between)
import Text.Parsec.Token
       (integer, float, whiteSpace, stringLiteral, makeTokenParser)
import Text.Parsec.Char (noneOf)
import Text.Parsec.Language (haskell)

data Val
  = Int Integer
  | Float Double
  | String String
  | Symbol String
  | List [Val]
  deriving (Eq, Show)

tProg :: Prim.ParsecT String a F.Identity [Val]
tProg = many tExpr <?> "program"
  where
    tExpr = between ws ws (tList <|> tAtom) <?> "expression"
    ws = whiteSpace haskell
    tAtom =
      (try (Float <$> float haskell) <?> "floating point number") <|>
      (try (Int <$> integer haskell) <?> "integer") <|>
      (String <$> stringLiteral haskell <?> "string") <|>
      (Symbol <$> many1 (noneOf "()\"\t\n\r ") <?> "symbol") <?>
      "atomic expression"
    tList = List <$> between (char '(') (char ')') (many tExpr) <?> "list"

p :: String -> IO ()
p = either print (putStrLn . unwords . map show) . parse tProg ""

main :: IO ()
main = do
  let expr =
        "((data \"quoted data\" 123 4.5)\n  (data (!@# (4.5) \"(more\" \"data)\")))"
  putStrLn ("The input:\n" ++ expr ++ "\n\nParsed as:")
  p expr
