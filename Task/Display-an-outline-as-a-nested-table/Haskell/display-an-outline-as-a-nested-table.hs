{-# LANGUAGE TupleSections #-}

module OutlineTree where

import Data.Bifunctor (first)
import Data.Bool (bool)
import Data.Char (isSpace)
import Data.List (find, intercalate)
import Data.Tree (Tree (..), foldTree, levels)

---------------- NESTED TABLES FROM OUTLINE --------------

wikiTablesFromOutline :: [String] -> String -> String
wikiTablesFromOutline colorSwatch outline =
  intercalate "\n\n" $
    wikiTableFromTree colorSwatch
      <$> ( forestFromLineIndents
              . indentLevelsFromLines
              . lines
          )
        outline

wikiTableFromTree :: [String] -> Tree String -> String
wikiTableFromTree colorSwatch =
  wikiTableFromRows
    . levels
    . paintedTree colorSwatch
    . widthLabelledTree
    . (paddedTree "" <*> treeDepth)

--------------------------- TEST -------------------------
main :: IO ()
main =
  ( putStrLn
      . wikiTablesFromOutline
        [ "#ffffe6",
          "#ffebd2",
          "#f0fff0",
          "#e6ffff",
          "#ffeeff"
        ]
  )
    "Display an outline as a nested table.\n\
    \    Parse the outline to a tree,\n\
    \        measuring the indent of each line,\n\
    \        translating the indentation to a nested structure,\n\
    \        and padding the tree to even depth.\n\
    \    count the leaves descending from each node,\n\
    \        defining the width of a leaf as 1,\n\
    \        and the width of a parent node as a sum.\n\
    \            (The sum of the widths of its children)\n\
    \    and write out a table with 'colspan' values\n\
    \        either as a wiki table,\n\
    \        or as HTML."

------------- TREE STRUCTURE FROM NESTED TEXT ------------

forestFromLineIndents :: [(Int, String)] -> [Tree String]
forestFromLineIndents = go
  where
    go [] = []
    go ((n, s) : xs) =
      let (subOutline, rest) = span ((n <) . fst) xs
       in Node s (go subOutline) : go rest

indentLevelsFromLines :: [String] -> [(Int, String)]
indentLevelsFromLines xs =
  let pairs = first length . span isSpace <$> xs
      indentUnit = maybe 1 fst (find ((0 <) . fst) pairs)
   in first (`div` indentUnit) <$> pairs

---------------- TREE PADDED TO EVEN DEPTH ---------------

paddedTree :: a -> Tree a -> Int -> Tree a
paddedTree padValue = go
  where
    go tree n
      | 1 >= n = tree
      | otherwise =
        Node
          (rootLabel tree)
          ( (`go` pred n)
              <$> bool nest [Node padValue []] (null nest)
          )
      where
        nest = subForest tree

treeDepth :: Tree a -> Int
treeDepth = foldTree go
  where
    go _ [] = 1
    go _ xs = (succ . maximum) xs

----------------- SUBTREE WIDTHS MEASURED ----------------

widthLabelledTree :: Tree a -> Tree (a, Int)
widthLabelledTree = foldTree go
  where
    go x [] = Node (x, 1) []
    go x xs =
      Node
        (x, foldr ((+) . snd . rootLabel) 0 xs)
        xs

------------------- COLOR SWATCH APPLIED -----------------

paintedTree :: [String] -> Tree a -> Tree (String, a)
paintedTree [] tree = fmap ("",) tree
paintedTree (color : colors) tree =
  Node
    (color, rootLabel tree)
    ( zipWith
        (fmap . (,))
        (cycle colors)
        (subForest tree)
    )

-------------------- WIKITABLE RENDERED ------------------

wikiTableFromRows :: [[(String, (String, Int))]] -> String
wikiTableFromRows rows =
  let wikiRow = unlines . fmap cellText
      cellText (color, (txt, width))
        | null txt = "| |"
        | otherwise =
          "| "
            <> cw color width
            <> "| "
            <> txt
      cw color width =
        let go w
              | 1 < w = " colspan=" <> show w
              | otherwise = ""
         in "style=\"background:"
              <> color
              <> "; \""
              <> go width
              <> " "
   in "{| class=\"wikitable\" "
        <> "style=\"text-align: center;\"\n|-\n"
        <> intercalate "|-\n" (wikiRow <$> rows)
        <> "|}"
