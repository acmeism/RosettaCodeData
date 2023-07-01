import Data.List
import Data.Ratio
import Control.Monad
import System.Environment (getArgs)

data Expr = Constant Rational |
    Expr :+ Expr | Expr :- Expr |
    Expr :* Expr | Expr :/ Expr
    deriving (Eq)

ops = [(:+), (:-), (:*), (:/)]

instance Show Expr where
    show (Constant x) = show $ numerator x
      -- In this program, we need only print integers.
    show (a :+ b)     = strexp "+" a b
    show (a :- b)     = strexp "-" a b
    show (a :* b)     = strexp "*" a b
    show (a :/ b)     = strexp "/" a b

strexp :: String -> Expr -> Expr -> String
strexp op a b = "(" ++ show a ++ " " ++ op ++ " " ++ show b ++ ")"

templates :: [[Expr] -> Expr]
templates = do
    op1 <- ops
    op2 <- ops
    op3 <- ops
    [\[a, b, c, d] -> op1 a $ op2 b $ op3 c d,
     \[a, b, c, d] -> op1 (op2 a b) $ op3 c d,
     \[a, b, c, d] -> op1 a $ op2 (op3 b c) d,
     \[a, b, c, d] -> op1 (op2 a $ op3 b c) d,
     \[a, b, c, d] -> op1 (op2 (op3 a b) c) d]

eval :: Expr -> Maybe Rational
eval (Constant c) = Just c
eval (a :+ b)     = liftM2 (+) (eval a) (eval b)
eval (a :- b)     = liftM2 (-) (eval a) (eval b)
eval (a :* b)     = liftM2 (*) (eval a) (eval b)
eval (a :/ b)     = do
    denom <- eval b
    guard $ denom /= 0
    liftM (/ denom) $ eval a

solve :: Rational -> [Rational] -> [Expr]
solve target r4 = filter (maybe False (== target) . eval) $
    liftM2 ($) templates $
    nub $ permutations $ map Constant r4

main = getArgs >>= mapM_ print . solve 24 . map (toEnum . read)
