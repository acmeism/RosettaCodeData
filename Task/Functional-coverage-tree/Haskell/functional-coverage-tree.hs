{-# LANGUAGE OverloadedStrings #-}

import Data.Bifunctor (first)
import Data.Bool (bool)
import Data.Char (isSpace)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Data.Text.Read as T
import Data.Tree (Forest, Tree (..), foldTree)
import Numeric (showFFloat)
import System.Directory (doesFileExist)

----------------- FUNCTIONAL COVERAGE TREE ---------------

data Coverage = Coverage
  { name :: T.Text,
    weight :: Float,
    coverage :: Float,
    share :: Float
  }
  deriving (Show)

--------------------------- TEST -------------------------
fp = "./coverageOutline.txt"

main :: IO ()
main =
  doesFileExist fp
    >>= bool
      (print $ "File not found: " <> fp)
      (T.readFile fp >>= T.putStrLn . updatedCoverageOutline)

----------------- UPDATED COVERAGE OUTLINE ---------------
updatedCoverageOutline :: T.Text -> T.Text
updatedCoverageOutline s =
  let delimiter = "|"
      indentedLines = T.lines s
      columnNames =
        init $
          tokenizeWith
            delimiter
            ( head indentedLines
            )
   in T.unlines
        [ tabulation
            delimiter
            (columnNames <> ["SHARE OF RESIDUE"]),
          indentedLinesFromTree
            "    "
            (showCoverage delimiter)
            $ withResidueShares 1.0 $
              foldTree
                weightedCoverage
                (parseTreeFromOutline delimiter indentedLines)
        ]

------ WEIGHTED COVERAGE AND SHARES OF REMAINING WORK ----
weightedCoverage ::
  Coverage ->
  Forest Coverage ->
  Tree Coverage
weightedCoverage x xs =
  let cws = ((,) . coverage <*> weight) . rootLabel <$> xs
      totalWeight = foldr ((+) . snd) 0 cws
   in Node
        ( x
            { coverage =
                foldr
                  (\(c, w) a -> (c * w) + a)
                  (coverage x)
                  cws
                  / bool 1 totalWeight (0 < totalWeight)
            }
        )
        xs

withResidueShares :: Float -> Tree Coverage -> Tree Coverage
withResidueShares shareOfTotal tree =
  let go fraction node =
        let forest = subForest node
            weights = weight . rootLabel <$> forest
            weightTotal = sum weights
            nodeRoot = rootLabel node
         in Node
              ( nodeRoot
                  { share =
                      fraction
                        * (1 - coverage nodeRoot)
                  }
              )
              ( zipWith
                  go
                  ((fraction *) . (/ weightTotal) <$> weights)
                  forest
              )
   in go shareOfTotal tree

---------------------- OUTLINE PARSE ---------------------
parseTreeFromOutline :: T.Text -> [T.Text] -> Tree Coverage
parseTreeFromOutline delimiter indentedLines =
  partialRecord . tokenizeWith delimiter
    <$> head
      ( forestFromLineIndents $
          indentLevelsFromLines $ tail indentedLines
      )

forestFromLineIndents :: [(Int, T.Text)] -> [Tree T.Text]
forestFromLineIndents pairs =
  let go [] = []
      go ((n, s) : xs) =
        let (firstTreeLines, rest) = span ((n <) . fst) xs
         in Node s (go firstTreeLines) : go rest
   in go pairs

indentLevelsFromLines :: [T.Text] -> [(Int, T.Text)]
indentLevelsFromLines xs =
  let pairs = T.span isSpace <$> xs
      indentUnit =
        foldr
          ( \x a ->
              let w = (T.length . fst) x
               in bool a w (w < a && 0 < w)
          )
          (maxBound :: Int)
          pairs
   in first (flip div indentUnit . T.length) <$> pairs

partialRecord :: [T.Text] -> Coverage
partialRecord xs =
  let [name, weightText, coverageText] =
        take
          3
          (xs <> repeat "")
   in Coverage
        { name = name,
          weight = defaultOrRead 1.0 weightText,
          coverage = defaultOrRead 0.0 coverageText,
          share = 0.0
        }

defaultOrRead :: Float -> T.Text -> Float
defaultOrRead n txt = either (const n) fst $ T.rational txt

tokenizeWith :: T.Text -> T.Text -> [T.Text]
tokenizeWith delimiter = fmap T.strip . T.splitOn delimiter

-------- SERIALISATION OF TREE TO TABULATED OUTLINE ------
indentedLinesFromTree ::
  T.Text ->
  (T.Text -> a -> T.Text) ->
  Tree a ->
  T.Text
indentedLinesFromTree tab showRoot tree =
  let go indent node =
        showRoot indent (rootLabel node) :
        (subForest node >>= go (T.append tab indent))
   in T.unlines $ go "" tree

showCoverage :: T.Text -> T.Text -> Coverage -> T.Text
showCoverage delimiter indent x =
  tabulation
    delimiter
    ( [T.append indent (name x), T.pack (showN 0 (weight x))]
        <> (T.pack . showN 4 <$> ([coverage, share] <*> [x]))
    )

tabulation :: T.Text -> [T.Text] -> T.Text
tabulation delimiter =
  T.intercalate (T.append delimiter " ")
    . zipWith (`T.justifyLeft` ' ') [31, 9, 9, 9]

justifyRight :: Int -> a -> [a] -> [a]
justifyRight n c = (drop . length) <*> (replicate n c <>)

showN :: Int -> Float -> String
showN p n = justifyRight 7 ' ' (showFFloat (Just p) n "")
