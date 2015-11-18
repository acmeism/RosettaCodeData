import Text.Parsec
import Text.Parsec.Expr
import Text.Parsec.Combinator
import Data.Functor

data Exp = Num Int
         | Add Exp Exp
         | Sub Exp Exp
         | Mul Exp Exp
         | Div Exp Exp

expr = buildExpressionParser table factor
    where table = [[op "*" (Mul) AssocLeft, op "/" (Div) AssocLeft]
                  ,[op "+" (Add) AssocLeft, op "-" (Sub) AssocLeft]]
          op s f assoc = Infix (f <$ string s) assoc
          factor =  (between `on` char) '(' ')' expr
                <|> (Num . read <$> many1 digit)
          on f g = \x y -> f (g x) (g y)

eval :: Num a => Exp -> a
eval e = case e of
    Num x   -> fromIntegral x
    Add a b -> eval a   +   eval b
    Sub a b -> eval a   -   eval b
    Mul a b -> eval a   *   eval b
    Div a b -> eval a `div` eval b

solution :: Num a => String -> a
solution = either (const (error "Did not parse")) eval . parse expr ""
