{-# LANGUAGE OverloadedStrings #-}

import Data.Tree (Tree(..), foldTree)
import qualified Data.Text.IO as T
import qualified Data.Text as T
import qualified Data.List as L
import Data.Bifunctor (first)
import Data.Ord (comparing)
import Data.Char (isSpace)


--------------- OUTLINE SORTED AT EVERY LEVEL --------------

sortedOutline :: (Tree T.Text -> Tree T.Text -> Ordering)
              -> T.Text
              -> Either T.Text T.Text
sortedOutline cmp outlineText =
  let xs = T.lines outlineText
  in consistentIndentUnit (nonZeroIndents xs) >>=
     \indentUnit ->
        let forest = forestFromLineIndents $ indentLevelsFromLines xs
            sortedForest =
              subForest $
              foldTree (\x xs -> Node x (L.sortBy cmp xs)) (Node "" forest)
        in Right $ outlineFromForest indentUnit sortedForest


--------------------------- TESTS --------------------------

main :: IO ()
main =
  mapM_ T.putStrLn $
  concat $
  [ \(comparatorLabel, cmp) ->
       (\kv ->
           let section = headedSection (fst kv) comparatorLabel
           in (either (section . (" -> " <>)) section . sortedOutline cmp . snd)
                kv) <$>
       [ ("Four-spaced", spacedOutline)
       , ("Tabbed", tabbedOutline)
       , ("First unknown type", confusedOutline)
       , ("Second unknown type", raggedOutline)
       ]
  ] <*>
  [("(A -> Z)", comparing rootLabel), ("(Z -> A)", flip (comparing rootLabel))]

headedSection :: T.Text -> T.Text -> T.Text -> T.Text
headedSection outlineType comparatorName x =
  T.concat ["\n", outlineType, " ", comparatorName, ":\n\n", x]

spacedOutline, tabbedOutline, confusedOutline, raggedOutline :: T.Text
spacedOutline =
  "zeta\n\
    \    beta\n\
    \    gamma\n\
    \        lambda\n\
    \        kappa\n\
    \        mu\n\
    \    delta\n\
    \alpha\n\
    \    theta\n\
    \    iota\n\
    \    epsilon"

tabbedOutline =
  "zeta\n\
    \\tbeta\n\
    \\tgamma\n\
    \\t\tlambda\n\
    \\t\tkappa\n\
    \\t\tmu\n\
    \\tdelta\n\
    \alpha\n\
    \\ttheta\n\
    \\tiota\n\
    \\tepsilon"

confusedOutline =
  "zeta\n\
    \    beta\n\
    \  gamma\n\
    \        lambda\n\
    \  \t    kappa\n\
    \        mu\n\
    \    delta\n\
    \alpha\n\
    \    theta\n\
    \    iota\n\
    \    epsilon"

raggedOutline =
  "zeta\n\
    \    beta\n\
    \   gamma\n\
    \        lambda\n\
    \         kappa\n\
    \        mu\n\
    \    delta\n\
    \alpha\n\
    \    theta\n\
    \    iota\n\
    \    epsilon"


-------- OUTLINE TREES :: SERIALIZED AND DESERIALIZED ------

forestFromLineIndents :: [(Int, T.Text)] -> [Tree T.Text]
forestFromLineIndents = go
  where
    go [] = []
    go ((n, s):xs) = Node s (go subOutline) : go rest
      where
        (subOutline, rest) = span ((n <) . fst) xs

indentLevelsFromLines :: [T.Text] -> [(Int, T.Text)]
indentLevelsFromLines xs = first (`div` indentUnit) <$> pairs
  where
    pairs = first T.length . T.span isSpace <$> xs
    indentUnit = maybe 1 fst (L.find ((0 <) . fst) pairs)

outlineFromForest :: T.Text -> [Tree T.Text] -> T.Text
outlineFromForest tabString forest = T.unlines $ forest >>= go ""
  where
    go indent node =
      indent <> rootLabel node :
      (subForest node >>= go (T.append tabString indent))

------ OUTLINE CHECKING - INDENT CHARACTERS AND WIDTHS -----
consistentIndentUnit :: [T.Text] -> Either T.Text T.Text
consistentIndentUnit prefixes = minimumIndent prefixes >>= checked prefixes
  where
    checked xs indentUnit
      | all ((0 ==) . (`rem` unitLength) . T.length) xs = Right indentUnit
      | otherwise =
        Left
          ("Inconsistent indent depths: " <>
           T.pack (show (T.length <$> prefixes)))
      where
        unitLength = T.length indentUnit

minimumIndent :: [T.Text] -> Either T.Text T.Text
minimumIndent prefixes = go $ T.foldr newChar "" $ T.concat prefixes
  where
    newChar c seen
      | c `L.elem` seen = seen
      | otherwise = c : seen
    go cs
      | 1 < length cs =
        Left $ "Mixed indent characters used: " <> T.pack (show cs)
      | otherwise = Right $ L.minimumBy (comparing T.length) prefixes

nonZeroIndents :: [T.Text] -> [T.Text]
nonZeroIndents textLines =
  [ s
  | x <- textLines
  , s <- [T.takeWhile isSpace x]
  , 0 /= T.length s ]
