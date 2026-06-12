import Data.Bifunctor (first)
import Data.List (intercalate, mapAccumL)
import qualified Data.Map.Strict as M
import Data.Maybe (fromMaybe)

type Tally = M.Map Char Int

-------------------- WORDLE COMPARISON -------------------

wordleScore :: String -> String -> [Int]
wordleScore target guess =
  snd $
    uncurry (mapAccumL amber) $
      first charCounts $
        mapAccumL green [] (zip target guess)

green :: String -> (Char, Char) -> (String, (Char, Int))
green residue (t, g)
  | t == g = (residue, (g, 2))
  | otherwise = (t : residue, (g, 0))

amber :: Tally -> (Char, Int) -> (Tally, Int)
amber tally (_, 2) = (tally, 2)
amber tally (c, _)
  | 0 < fromMaybe 0 (M.lookup c tally) =
      (M.adjust pred c tally, 1)
  | otherwise = (tally, 0)

charCounts :: String -> Tally
charCounts =
  foldr
    (flip (M.insertWith (+)) 1)
    M.empty

--------------------------- TEST -------------------------
main :: IO ()
main = do
  putStrLn $ intercalate " -> " ["Target", "Guess", "Scores"]
  putStrLn []
  mapM_ (either putStrLn putStrLn) $
    uncurry wordleReport
      <$> [ ("ALLOW", "LOLLY"),
            ("CHANT", "LATTE"),
            ("ROBIN", "ALERT"),
            ("ROBIN", "SONIC"),
            ("ROBIN", "ROBIN"),
            ("BULLY", "LOLLY"),
            ("ADAPT", "SÅLÅD"),
            ("Ukraine", "Ukraíne"),
            ("BBAAB", "BBBBBAA"),
            ("BBAABBB", "AABBBAA")
          ]

wordleReport :: String -> String -> Either String String
wordleReport target guess
  | 5 /= length target =
      Left (target <> ": Expected 5 character target.")
  | 5 /= length guess =
      Left (guess <> ": Expected 5 character guess.")
  | otherwise =
      let scores = wordleScore target guess
       in Right
            ( intercalate
                " -> "
                [ target,
                  guess,
                  show scores,
                  unwords (color <$> scores)
                ]
            )

color 2 = "green"
color 1 = "amber"
color _ = "gray"
