import Prelude hiding (lookup)
import Data.Map.Strict (Map, fromList, lookup)
import Data.List (inits, intercalate)
import Data.Maybe (fromMaybe)
import Data.Bool (bool)

main :: IO ()
main = (putStrLn . unlines) (ingestion <$> meal)

meal :: [[String]]
meal = init (reverse <$> tail (inits menu)) ++ [[last menu]]

menu :: [String]
menu = fst <$> courses

courses :: [(String, String)]
courses =
  [ ("fly", "I don't know why she swallowed a fly - perhaps she'll die")
  , ("spider", "It wiggled and jiggled and tickled inside her")
  , ("bird", "How absurd, to swallow a bird")
  , ("cat", "Imagine that. She swallowed a cat")
  , ("dog", "What a hog to swallow a dog")
  , ("goat", "She just opened her throat and swallowed a goat")
  , ("cow", "I don't know how she swallowed a cow")
  , ("horse", "She died, of course")
  ]

ingestion :: [String] -> String
ingestion [] = []
ingestion dishes =
  let appetiser = head dishes
      story = motivation dishes
  in concat
       [ "\nThere was an old lady who swallowed a "
       , appetiser
       , ";\n"
       , reputation appetiser
       , "."
       , bool ("\n\n" ++ story ++ ".") [] (null story)
       ]

motivation :: [String] -> String
motivation [] = []
motivation dishes =
  intercalate ";\n" $
  zipWith
    (\a b -> concat ["She swallowed the ", a, " to catch the ", fullName b])
    dishes
    (tail dishes)

fullName :: String -> String
fullName dish
  | "spider" == dish =
    dish ++ "\nthat " ++ unwords (tail (words (reputation dish)))
  | "fly" == dish = dish ++ ".\n" ++ reputation dish
  | otherwise = dish

reputation :: String -> String
reputation = fromMaybe [] . flip lookup comments

comments :: Map String String
comments = fromList courses
