import Control.Applicative hiding (many, some)
import Control.Monad.State.Lazy
import Control.Monad.Trans.Maybe (MaybeT, runMaybeT)
import Data.Char (isAsciiLower, isAsciiUpper, isDigit, ord)
import Data.Foldable (asum)
import Data.Functor (($>))
import Data.Text (Text)
import qualified Data.Text as T
import Prelude hiding (lex)
import System.Environment (getArgs)
import System.IO
import Text.Printf


-- Tokens --------------------------------------------------------------------------------------------------------------
data Val = IntVal    Int            -- value
         | TextVal   String Text    -- name value
         | SymbolVal String         -- name
         | Skip
         | LexError  String         -- message

data Token = Token Val Int Int    -- value line column


instance Show Val where
    show (IntVal             value) = printf "%-18s%d\n" "Integer" value
    show (TextVal   "String" value) = printf "%-18s%s\n" "String" (show $ T.unpack value)    -- show escaped characters
    show (TextVal   name     value) = printf "%-18s%s\n" name (T.unpack value)
    show (SymbolVal name          ) = printf "%s\n"      name
    show (LexError  msg           ) = printf "%-18s%s\n" "Error" msg
    show Skip                       = printf ""

instance Show Token where
    show (Token val line column) = printf "%2d   %2d   %s" line column (show val)


printTokens :: [Token] -> String
printTokens tokens =
    "Location  Token name        Value\n"      ++
    "--------------------------------------\n" ++
    (concatMap show tokens)


-- Tokenizers ----------------------------------------------------------------------------------------------------------
makeToken :: Lexer Val -> Lexer Token
makeToken lexer = do
    (t, l, c) <- get
    val <- lexer

    case val of
        Skip -> nextToken

        LexError msg -> do
            (_, l', c') <- get

            let code = T.unpack $ T.take (c' - c + 1) t
            let str = printf "%s\n%s(%d, %d): %s" msg (replicate 27 ' ') l' c' code

            ch <- peek
            unless (ch == '\0') $ advance 1

            return $ Token (LexError str) l c

        _ -> return $ Token val l c


simpleToken :: String -> String -> Lexer Val
simpleToken lexeme name = lit lexeme $> SymbolVal name


makeTokenizers :: [(String, String)] -> Lexer Val
makeTokenizers = asum . map (uncurry simpleToken)


keywords :: Lexer Val
keywords = makeTokenizers
    [("if",    "Keyword_if"),    ("else", "Keyword_else"), ("while", "Keyword_while"),
     ("print", "Keyword_print"), ("putc", "Keyword_putc")]


operators :: Lexer Val
operators = makeTokenizers
    [("*", "Op_multiply"), ("/",  "Op_divide"),    ("%",  "Op_mod"),      ("+", "Op_add"),
     ("-", "Op_subtract"), ("<=", "Op_lessequal"), ("<",  "Op_less"),     (">=", "Op_greaterequal"),
     (">", "Op_greater"),  ("==", "Op_equal"),     ("!=", "Op_notequal"), ("!", "Op_not"),
     ("=", "Op_assign"),   ("&&", "Op_and"),       ("||", "Op_or")]


symbols :: Lexer Val
symbols = makeTokenizers
    [("(", "LeftParen"), (")", "RightParen"),
     ("{", "LeftBrace"), ("}", "RightBrace"),
     (";", "Semicolon"), (",", "Comma")]


isIdStart :: Char -> Bool
isIdStart ch = isAsciiLower ch || isAsciiUpper ch || ch == '_'

isIdEnd :: Char -> Bool
isIdEnd ch = isIdStart ch || isDigit ch

identifier :: Lexer Val
identifier = TextVal "Identifier" <$> lexeme
    where lexeme = T.cons <$> (one isIdStart) <*> (many isIdEnd)


integer :: Lexer Val
integer = do
    lexeme <- some isDigit
    next_ch <- peek

    if (isIdStart next_ch) then
        return $ LexError "Invalid number. Starts like a number, but ends in non-numeric characters."
    else do
        let num = read (T.unpack lexeme) :: Int
        return $ IntVal num


character :: Lexer Val
character = do
    lit "'"
    str <- lookahead 3

    case str of
        (ch : '\'' : _)    -> advance 2 $> IntVal (ord ch)
        "\\n'"             -> advance 3 $> IntVal 10
        "\\\\'"            -> advance 3 $> IntVal 92
        ('\\' : ch : "\'") -> advance 2 $> LexError (printf "Unknown escape sequence \\%c" ch)
        ('\'' : _)         -> return $ LexError "Empty character constant"
        _                  -> advance 2 $> LexError "Multi-character constant"


string :: Lexer Val
string = do
    lit "\""

    loop (T.pack "") =<< peek
        where loop t ch = case ch of
                  '\\' -> do
                      next_ch <- next

                      case next_ch of
                          'n'  -> loop (T.snoc t '\n') =<< next
                          '\\' -> loop (T.snoc t '\\') =<< next
                          _    -> return $ LexError $ printf "Unknown escape sequence \\%c" next_ch

                  '"' -> next $> TextVal "String" t

                  '\n' -> return $ LexError $ "End-of-line while scanning string literal." ++
                                              " Closing string character not found before end-of-line."

                  '\0' -> return $ LexError $ "End-of-file while scanning string literal." ++
                                              " Closing string character not found."

                  _    -> loop (T.snoc t ch) =<< next


skipComment :: Lexer Val
skipComment = do
    lit "/*"

    loop =<< peek
        where loop ch = case ch of
                  '\0' -> return $ LexError "End-of-file in comment. Closing comment characters not found."

                  '*'  -> do
                      next_ch <- next

                      case next_ch of
                          '/' -> next $> Skip
                          _   -> loop next_ch

                  _    -> loop =<< next


nextToken :: Lexer Token
nextToken = do
    skipWhitespace

    makeToken $ skipComment
            <|> keywords
            <|> identifier
            <|> integer
            <|> character
            <|> string
            <|> operators
            <|> symbols
            <|> simpleToken "\0" "End_of_input"
            <|> (return $ LexError "Unrecognized character.")


main :: IO ()
main = do
    args <- getArgs
    (hin, hout) <- getIOHandles args

    withHandles hin hout $ printTokens . (lex nextToken)


------------------------------------------------------------------------------------------------------------------------
-- Machinery
------------------------------------------------------------------------------------------------------------------------

-- File handling -------------------------------------------------------------------------------------------------------
getIOHandles :: [String] -> IO (Handle, Handle)
getIOHandles [] = return (stdin, stdout)

getIOHandles [infile] = do
    inhandle <- openFile infile ReadMode
    return (inhandle, stdout)

getIOHandles (infile : outfile : _) = do
    inhandle  <- openFile infile ReadMode
    outhandle <- openFile outfile WriteMode
    return (inhandle, outhandle)


withHandles :: Handle -> Handle -> (String -> String) -> IO ()
withHandles in_handle out_handle f = do
    contents <- hGetContents in_handle
    let contents' = contents ++ "\0"    -- adding \0 simplifies treatment of EOF

    hPutStr out_handle $ f contents'

    unless (in_handle == stdin) $ hClose in_handle
    unless (out_handle == stdout) $ hClose out_handle


-- Lexer ---------------------------------------------------------------------------------------------------------------
type LexerState = (Text, Int, Int)    -- input line column
type Lexer = MaybeT (State LexerState)


lexerAdvance :: Int -> LexerState -> LexerState
lexerAdvance 0 ctx = ctx

lexerAdvance 1 (t, l, c)
    | ch == '\n' = (rest, l + 1, 1    )
    | otherwise  = (rest, l,     c + 1)
    where
        (ch, rest) = (T.head t, T.tail t)

lexerAdvance n ctx = lexerAdvance (n - 1) $ lexerAdvance 1 ctx


advance :: Int -> Lexer ()
advance n = modify $ lexerAdvance n


peek :: Lexer Char
peek = gets $ \(t, _, _) -> T.head t


lookahead :: Int -> Lexer String
lookahead n = gets $ \(t, _, _) -> T.unpack $ T.take n t


next :: Lexer Char
next = advance 1 >> peek


skipWhitespace :: Lexer ()
skipWhitespace = do
    ch <- peek
    when (ch `elem` " \n") (next >> skipWhitespace)


lit :: String -> Lexer ()
lit lexeme = do
    (t, _, _) <- get
    guard $ T.isPrefixOf (T.pack lexeme) t
    advance $ length lexeme


one :: (Char -> Bool) -> Lexer Char
one f = do
    ch <- peek
    guard $ f ch
    next
    return ch


lexerMany :: (Char -> Bool) -> LexerState -> (Text, LexerState)
lexerMany f (t, l, c) = (lexeme, (t', l', c'))
    where (lexeme, _) = T.span f t
          (t', l', c') = lexerAdvance (T.length lexeme) (t, l, c)


many :: (Char -> Bool) -> Lexer Text
many f = state $ lexerMany f


some :: (Char -> Bool) -> Lexer Text
some f = T.cons <$> (one f) <*> (many f)


lex :: Lexer a -> String -> [a]
lex lexer str = loop lexer (T.pack str, 1, 1)
    where loop lexer s
              | T.null txt = [t]
              | otherwise  = t : loop lexer s'

              where (Just t, s') = runState (runMaybeT lexer) s
                    (txt, _, _) = s'
