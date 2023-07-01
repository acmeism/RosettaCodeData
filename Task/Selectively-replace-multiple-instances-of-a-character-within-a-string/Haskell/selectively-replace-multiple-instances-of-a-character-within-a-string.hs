import Data.List (mapAccumL)
import qualified Data.Map.Strict as M
import Data.Maybe (fromMaybe)

---------- POSITIONAL CHARACTER-REPLACEMENT RULES --------

nthCharsReplaced :: M.Map Char [Maybe Char] -> String -> String
nthCharsReplaced ruleMap = snd . mapAccumL go ruleMap
  where
    go a c =
      case M.lookup c a of
        Nothing -> (a, c)
        Just [] -> (a, c)
        Just (d : ds) ->
          ( M.insert c ds a,
            fromMaybe c d
          )

--------------------------- TEST -------------------------
main :: IO ()
main = putStrLn $ nthCharsReplaced rules "abracadabra"

rules :: M.Map Char [Maybe Char]
rules =
  M.fromList
    [ ('a', (Just <$> "AB") <> [Nothing] <> (Just <$> "CD")),
      ('b', [Just 'E']),
      ('r', [Nothing, Just 'F'])
    ]
