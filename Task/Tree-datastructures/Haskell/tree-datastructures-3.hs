import Data.Bifunctor (bimap, first)
import Data.Char (isSpace)
import Data.List (find)
import Data.Tree (Forest, Tree (..), drawTree)

-------- MAPPINGS BETWEEN INDENTED LINES AND TREES -------

forestFromNestLevels :: [(Int, String)] -> Forest String
forestFromNestLevels = go
  where
    go [] = []
    go ((n, v) : xs) =
      uncurry (:) $
        bimap (Node v . go) go (span ((n <) . fst) xs)

indentLevelsFromLines :: [String] -> [(Int, String)]
indentLevelsFromLines xs =
  let pairs = first length . span isSpace <$> xs
      indentUnit = maybe 1 fst (find ((0 <) . fst) pairs)
   in first (`div` indentUnit) <$> pairs

outlineFromForest ::
  (String -> String -> String) ->
  String ->
  Forest String ->
  String
outlineFromForest showRoot tabString forest =
  let go indent node =
        showRoot indent (rootLabel node) :
        (subForest node >>= go ((<>) tabString indent))
   in unlines $ forest >>= go ""

-------------------------- TESTS -------------------------
main :: IO ()
main = do
  putStrLn "Tree representation parsed directly:\n"
  putStrLn $ drawTree $ Node "" nativeForest

  let levelPairs = indentLevelsFromLines test
  putStrLn "\n[(Level, Text)] list from lines:\n"
  mapM_ print levelPairs

  putStrLn "\n\nTrees from indented text:\n"
  let trees = forestFromNestLevels levelPairs
  putStrLn $ drawTree $ Node "" trees

  putStrLn "Indented text from trees:\n"
  putStrLn $ outlineFromForest (<>) "    " trees

test :: [String]
test =
  [ "RosettaCode",
    "    rocks",
    "        code",
    "        comparison",
    "        wiki",
    "    mocks",
    "        trolling",
    "Some lists",
    "            may",
    "        be",
    "    irregular"
  ]

nativeForest :: Forest String
nativeForest =
  [ Node
      "RosettaCode"
      [ Node
          "rocks"
          [ Node "code" [],
            Node "comparison" [],
            Node "wiki" []
          ],
        Node
          "mocks"
          [Node "trolling" []]
      ],
    Node
      "Some lists"
      [ Node "may" [],
        Node "be" [],
        Node "irregular" []
      ]
  ]
