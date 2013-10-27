{-# LANGUAGE LambdaCase #-}
import Control.Applicative
import Control.Lens
import Control.Monad.Error
import Control.Monad.State
import System.Console.Readline

data InToken = InOp Op | InVal Int | LParen | RParen deriving (Show)
data OutToken = OutOp Op | OutVal Int
data StackElem = StOp Op | Paren deriving (Show)
data Op = Pow | Mul | Div | Add | Sub deriving (Show)
data Assoc = L | R deriving (Eq)

type Env = ([OutToken], [StackElem])
type RPNComp = StateT Env (Either String)

instance Show OutToken where
    show (OutOp x) = snd $ opInfo x
    show (OutVal v) = show v

opInfo = \case
    Pow -> (4, "^")
    Mul -> (3, "*")
    Div -> (3, "/")
    Add -> (2, "+")
    Sub -> (2, "-")

prec = fst . opInfo
leftAssoc Pow = False
leftAssoc _   = True

--Stateful actions
processToken :: InToken -> RPNComp ()
processToken = \case
    (InVal z) -> pushVal z
    (InOp op) -> pushOp op
    LParen    -> pushParen
    RParen    -> pushTillParen

pushTillParen :: RPNComp ()
pushTillParen = use _2 >>= \case
    []     -> throwError "Unmatched right parenthesis"
    (s:st) -> case s of
         StOp o -> _1 %= (OutOp o:) >> _2 %= tail >> pushTillParen
         Paren  -> _2 %= tail

pushOp :: Op -> RPNComp ()
pushOp o = use _2 >>= \case
    [] -> _2 .= [StOp o]
    (s:st) -> case s of
        (StOp o2) -> if leftAssoc o && prec o == prec o2
                     || prec o < prec o2
                     then _1 %= (OutOp o2:) >> _2 %= tail >> pushOp o
                     else _2 %= (StOp o:)
        Paren     -> _2 %= (StOp o:)

pushVal :: Int -> RPNComp ()
pushVal n = _1 %= (OutVal n:)

pushParen :: RPNComp ()
pushParen = _2 %= (Paren:)

--Run StateT. `process` is effectively foldM_ with the base case to
--format the output string
toRPN :: [InToken] -> Either String [OutToken]
toRPN xs = evalStateT (process (return ()) xs) ([],[])
    where process st [] = st >> get >>= \(a,b) -> (reverse a++) <$>
                                                    (mapM toOut b)
          process st (x:xs) = process (st >> processToken x) xs
          toOut :: StackElem -> RPNComp OutToken
          toOut (StOp o) = return $ OutOp o
          toOut Paren    = throwError "Unmatched left parenthesis"

--Parsing
readTokens :: String -> Either String [InToken]
readTokens = mapM f . words
    where f = let g = return . InOp in \case {
            "^" -> g Pow; "*" -> g Mul; "/" -> g Div;
            "+" -> g Add; "-" -> g Sub; "(" -> return LParen;
            ")" -> return RParen;
            a   -> case reads a of
                [] -> throwError $ "Invalid token `" ++ a ++ "`"
                [(_,x:[])] -> throwError $ "Invalid token `" ++ a ++ "`"
                [(v,[])]    -> return $ InVal v }

--Showing
showOutput (Left msg) = msg
showOutput (Right xs) = unwords $ map show xs

main = do
    a <- readline "Enter expression: "
    case a of
        Nothing -> putStrLn "Please enter a line" >> main
        Just "exit" -> return ()
        Just l      -> addHistory l >> case readTokens l of
            Left msg -> putStrLn msg >> main
            Right ts -> putStrLn (showOutput (toRPN ts)) >> main
