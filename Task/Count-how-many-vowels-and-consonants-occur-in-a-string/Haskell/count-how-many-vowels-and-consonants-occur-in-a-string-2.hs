import Control.Monad (join)
import Data.Bifunctor (bimap)
import Data.Char (isAlpha)
import Data.List (intercalate, partition)
import qualified Data.Map.Strict as M

------------ COUNTS OF EACH VOWEL AND CONSONANT ----------

vowelAndConsonantCounts ::
  String ->
  ([(Char, Int)], [(Char, Int)])
vowelAndConsonantCounts =
  join bimap M.toList
    . M.partitionWithKey (const . isVowel)
    . fst
    . M.partitionWithKey (const . isAlpha)
    . charCounts

charCounts :: String -> M.Map Char Int
charCounts =
  foldr
    (flip (M.insertWith (+)) 1)
    M.empty

isVowel :: Char -> Bool
isVowel = (`elem` "aeiouAEIOU")

--------------------------- TEST -------------------------
main :: IO ()
main = do
  let (v, c) =
        vowelAndConsonantCounts
          "Forever Fortran 2018 programming language"
      (vTotal, cTotal) =
        both
          (foldr ((+) . snd) 0)
          (v, c)

  putStrLn $
    unlines $
      [ show (vTotal + cTotal)
          <> " 'vowels and consonants'\n"
      ]
        <> fmap
          ('\t' :)
          ( concatMap
              report
              [ ("vowels", vTotal, v),
                ("consonants", cTotal, c)
              ]
          )

------------------------ FORMATTING ----------------------

report :: (String, Int, [(Char, Int)]) -> [String]
report (label, total, xs) =
  [ show total
      <> ( " characters drawn from "
             <> show (length xs)
             <> (' ' : label)
             <> ":"
         )
  ]
    <> (('\t' :) . show <$> xs)
    <> [""]

------------------------- GENERIC ------------------------

both :: (a -> b) -> (a, a) -> (b, b)
both = join bimap
