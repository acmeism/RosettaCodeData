import System.IO
import Data.List
import Text.Parsec
import Control.Applicative hiding ((<|>), many)

data WHNF = SYM !Char | FUN (WHNF -> WHNF)

fun :: WHNF -> WHNF -> WHNF
fun (SYM c) _ = error $ "Cannot apply symbol " ++ [c]
fun (FUN f) w = f w

expr :: Monad m => ParsecT String u m ([WHNF] -> WHNF)
expr = char '0' *> (buildLambda <$ char '0' <*> expr
               <|>  buildApply  <$ char '1' <*> expr <*> expr)
               <|> buildVar <$> pred.length <$> many (char '1') <* char '0' where
    buildLambda e env = FUN $ \arg -> e (arg:env)
    buildApply e1 e2 env = e1 env `fun` e2 env
    buildVar n env = env !! n

buildIO prog = whnfToString . (prog [] `fun` ) . stringToWhnf where
    stringToWhnf :: [Char] -> WHNF
    stringToWhnf = foldr (whnfCons . bitToWhnf . fromEnum) whnfFalse where
        bitToWhnf :: Integral a => a -> WHNF
        bitToWhnf n = if even n then whnfTrue else whnfFalse

        whnfCons :: WHNF -> WHNF -> WHNF
        whnfCons fw gw = FUN $ \hw -> hw `fun` fw `fun` gw

    whnfToString = map whnfToChar . whnfToList where
        cons2sym :: WHNF
        cons2sym = whnfConst . whnfConst $ SYM ':'

        whnfToList :: WHNF -> [WHNF]
        whnfToList l = case (l `fun` cons2sym) of
               SYM ':' -> l `fun` whnfTrue : whnfToList (l `fun` whnfFalse)
               FUN  _  -> []

        whnfToChar :: WHNF -> Char
        whnfToChar iw = c where (SYM c) = iw `fun` SYM '0' `fun` SYM '1'

    whnfConst :: WHNF -> WHNF
    whnfConst = FUN . const

    whnfTrue :: WHNF
    whnfTrue  = FUN whnfConst

    whnfFalse :: WHNF
    whnfFalse = whnfConst $ FUN id

main = do
    hSetBuffering stdout NoBuffering
    interact $ either (error . show) id . parse (buildIO <$> expr <*> getInput) ""
