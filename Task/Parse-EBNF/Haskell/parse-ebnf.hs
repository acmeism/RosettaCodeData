import Control.Applicative
import Control.Monad
import Data.Maybe
import qualified Data.Map as M
import System.Environment (getArgs)
import Text.Parsec hiding (many, optional, (<|>))
import Text.Parsec.String
import Text.Parsec.Error

-----------------------------------------------------------------
-- Main
-----------------------------------------------------------------

main = do
{- Uses the EBNF grammar contained in the first file to parse
the second file, then prints a parse tree. -}
    [grammar_file, other_file] <- getArgs
    ebnf_text <- readFile grammar_file
    case parseGrammar grammar_file ebnf_text of
        Left  err ->
            putStrLn $ "Failed to parse EBNF grammar: " ++ show err
        Right g   -> do
            putStrLn "Successfully parsed EBNF grammar."
            o <- readFile other_file
            case parseWithGrammar g other_file o of
                Left err ->
                    putStrLn $ "Failed to parse second file: " ++ show err
                Right tree ->
                    print tree

-----------------------------------------------------------------
-- Types and user functions
-----------------------------------------------------------------

parseGrammar :: FilePath -> String -> Either ParseError Grammar
parseGrammar fp s =
    case runParser ebnf M.empty fp s of
        Left e ->
            Left e
        Right (Grammar g, usedNames) ->
            let undefinedRules = foldl (flip M.delete) usedNames $ map fst g
                (undefName, undefNamePos) = M.findMin undefinedRules
            in if   M.null undefinedRules
               then Right $ Grammar g
               else Left $ newErrorMessage
                        (Message $ "Undefined rule: " ++ undefName)
                        undefNamePos

parseWithGrammar :: Grammar -> FilePath -> String -> Either ParseError ParseTree
parseWithGrammar g@(Grammar ((_, firstR) : _)) fp s =
    runParser (liftA cleanTree $ firstR <* eof) g fp s

type GParser = Parsec String UsedNames
type UsedNames = M.Map String SourcePos

type Rule = Parsec String Grammar ParseTree
 -- We need to keep the Grammar around as a Parsec user state
 -- to look up named rules.
data Grammar = Grammar [(String, Rule)]
 -- Grammar would be a type synonym instead of an ADT, but
 -- infinite types aren't allowed in Haskell.

data ParseTree =
    ParseBranch String [ParseTree] |
    ParseLeaf String

instance Show ParseTree where
      show = showIndented 0
--    show (ParseBranch "" t) = '[' : concatMap ((' ' :) . show) t ++ "]"
--    show (ParseBranch s  t) = '(' : s ++ concatMap ((' ' :) . show) t ++ ")"
--    show (ParseLeaf s)      = show s

showIndented :: Int -> ParseTree -> String
showIndented i (ParseBranch "" []) =
    indent i "[]"
showIndented i (ParseBranch "" t) =
    indent i "[" ++
    concatMap (showIndented (i + 2)) t ++
    "]"
showIndented i (ParseBranch s  t) =
    indent i ("(" ++ s) ++
    concatMap (showIndented (i + 2)) t ++
    ")"
showIndented i (ParseLeaf s)      =
    indent i $ show s

indent :: Int -> String -> String
indent i s = "\n" ++ replicate i ' ' ++ s

cleanTree :: ParseTree -> ParseTree
-- Removes empty anonymous branches.
cleanTree (ParseBranch i ts) =
    ParseBranch i $ map cleanTree $ filter p ts
  where p (ParseBranch "" []) = False
        p _                   = True
cleanTree x                 = x

-----------------------------------------------------------------
-- GParser definitions
-----------------------------------------------------------------

ebnf :: GParser (Grammar, UsedNames)
ebnf = liftA2 (,) (ws *> syntax <* eof) getState

syntax :: GParser Grammar
syntax = liftA Grammar $
    optional title *>
    lcbtw '{' '}' (many production) <*
    optional comment

production :: GParser (String, Rule)
production = do
    i <- identifier
    lc '='
    r <- expression
    oneOf ".;"
    ws
    return (i, liftM (nameBranch i) r)
  where nameBranch i (ParseBranch _ l) = ParseBranch i l

expression, term :: GParser Rule
expression = liftA (foldl1 (<|>)) $ term `sepBy1` (lc '|')
term = liftA (branch . sequence) $ many1 factor

factor :: GParser Rule
factor = liftA try $
    liftA ruleByName rememberName <|>
    liftA (leaf . (<* ws) . string) literal <|>
    liftA perhaps (lcbtw '[' ']' expression) <|>
    lcbtw '(' ')' expression <|>
    liftA (branch . many) (lcbtw '{' '}' expression)
  where rememberName :: GParser String
        rememberName = do
            i <- identifier
            p <- getPosition
            modifyState $ M.insertWith (flip const) i p
              {- Adds i → p to the state only if i doesn't
              already have an entry. This ensures we report the
              *first* usage of each unknown identifier. -}
            return i

        ruleByName :: String -> Rule
        ruleByName name = do
            Grammar g <- getState
            fromJust (lookup name g) <?> name

        perhaps = option $ ParseLeaf ""

identifier :: GParser String
identifier = many1 (noneOf " \t\n=|(){}[].;\"'") <* ws

title = literal

comment = literal

literal =
       (lc '\'' *> manyTill anyChar (lc '\'')) <|>
       (lc '"'  *> manyTill anyChar (lc '"'))
    <* ws

-----------------------------------------------------------------
-- Miscellany
-----------------------------------------------------------------

leaf = liftA ParseLeaf
branch = liftA $ ParseBranch ""

lcbtw c1 c2 = between (lc c1) (lc c2)

lc :: Char -> GParser Char
lc c = char c <* ws

ws = many $ oneOf " \n\t"
