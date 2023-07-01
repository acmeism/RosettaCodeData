{-# LANGUAGE TupleSections #-}

import Data.Bifunctor (bimap)
import Data.List (mapAccumL)
import Data.List.Split (splitOn)
import Data.Maybe (catMaybes, fromMaybe, listToMaybe)
import Data.Tree (Forest, Tree (..), drawForest)

------------------------ DATA TYPE -----------------------
data Val
  = Int Integer
  | Float Double
  | String String
  | Symbol String
  | List [Val]
  deriving (Eq, Show, Read)

instance Semigroup Val where
  List a <> List b = List (a <> b)

instance Monoid Val where
  mempty = List []

--------------------------- MAIN -------------------------
main :: IO ()
main = do
  let expr =
        unlines
          [ "((data \"quoted data\" 123 4.5)",
            "  (data (!@# (4.5) \"(more\" \"data)\")))"
          ]
      parse = fst (parseExpr (tokenized expr))

  putStrLn $ treeDiagram $ forestFromVal parse
  putStrLn "Serialized from the parse tree:\n"
  putStrLn $ litVal parse

------------------- S-EXPRESSION PARSER ------------------

parseExpr :: [String] -> (Val, [String])
parseExpr = until finished parseToken . (mempty,)

finished :: (Val, [String]) -> Bool
finished (_, []) = True
finished (_, token : _) = ")" == token

parseToken :: (Val, [String]) -> (Val, [String])
parseToken (v, "(" : rest) =
  bimap
    ((v <>) . List . return)
    tail
    (parseExpr rest)
parseToken (v, ")" : rest) = (v, rest)
parseToken (v, t : rest) = (v <> List [atom t], rest)

----------------------- TOKEN PARSER ---------------------

atom :: String -> Val
atom [] = mempty
atom s@('"' : _) =
  fromMaybe mempty (maybeRead ("String " <> s))
atom s =
  headDef (Symbol s) $
    catMaybes $
      maybeRead . (<> (' ' : s)) <$> ["Int", "Float"]

maybeRead :: String -> Maybe Val
maybeRead = fmap fst . listToMaybe . reads

----------------------- TOKENIZATION ---------------------

tokenized :: String -> [String]
tokenized s = quoteTokens '"' s >>= go
  where
    go [] = []
    go token@('"' : _) = [token]
    go s = words $ spacedBrackets s

quoteTokens :: Char -> String -> [String]
quoteTokens q s = snd $ mapAccumL go False (splitOn [q] s)
  where
    go b s
      | b = (False, '"' : s <> "\"")
      | otherwise = (True, s)

spacedBrackets :: String -> String
spacedBrackets [] = []
spacedBrackets (c : cs)
  | c `elem` "()" = ' ' : c : " " <> spacedBrackets cs
  | otherwise = c : spacedBrackets cs

------------------------- DIAGRAMS -----------------------

treeDiagram :: Forest Val -> String
treeDiagram = drawForest . fmap (fmap show)

forestFromVal :: Val -> Forest Val
forestFromVal (List xs) = treeFromVal <$> xs

treeFromVal :: Val -> Tree Val
treeFromVal (List xs) =
  Node (Symbol "List") (treeFromVal <$> xs)
treeFromVal v = Node v []

---------------------- SERIALISATION ---------------------

litVal (Symbol x) = x
litVal (Int x) = show x
litVal (Float x) = show x
litVal (String x) = '"' : x <> "\""
litVal (List [List xs]) = litVal (List xs)
litVal (List xs) = '(' : (unwords (litVal <$> xs) <> ")")

------------------------- GENERIC ------------------------

headDef :: a -> [a] -> a
headDef d [] = d
headDef _ (x : _) = x
