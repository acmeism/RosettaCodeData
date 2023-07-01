import Data.Function (on)
import Data.List (groupBy, maximum, sortBy, sortOn)
import qualified Data.Map as M
import Data.Maybe (mapMaybe)
import Data.Ord (comparing)

------------------------ TEXTONYMS -----------------------

digitEncoded ::
  M.Map Char Char ->
  [String] ->
  [(String, String)]
digitEncoded dict =
  mapMaybe $
    ((>>=) . traverse (`M.lookup` dict))
      <*> curry Just

charDict :: M.Map Char Char
charDict =
  M.fromList $
    concat $
      zipWith
        (fmap . flip (,))
        (head . show <$> [2 ..])
        (words "abc def ghi jkl mno pqrs tuv wxyz")

definedSamples ::
  Int ->
  [[(String, String)]] ->
  [[(String, String)] -> Int] ->
  [[[(String, String)]]]
definedSamples n xs fs =
  [take n . flip sortBy xs] <*> (flip . comparing <$> fs)

--------------------------- TEST -------------------------
main :: IO ()
main = do
  let fp = "unixdict.txt"
  s <- readFile fp
  let encodings = digitEncoded charDict $ lines s
      codeGroups =
        groupBy
          (on (==) snd)
          . sortOn snd
          $ encodings
      textonyms = filter ((1 <) . length) codeGroups
  mapM_
    putStrLn
    [ "There are "
        <> show (length encodings)
        <> " words in "
        <> fp
        <> " which can be represented\n"
        <> "by the digit key mapping.",
      "\nThey require "
        <> show (length codeGroups)
        <> " digit combinations to represent them.",
      show (length textonyms)
        <> " digit combinations represent textonyms.",
      ""
    ]
  let codeLength = length . snd . head
      [ambiguous, longer] =
        definedSamples
          5
          textonyms
          [length, codeLength]
      [wa, wl] =
        maximum . fmap codeLength
          <$> [ambiguous, longer]
  mapM_ putStrLn $
    "Five most ambiguous:" :
    fmap (showTextonym wa) ambiguous
      <> ( "" :
           "Five longest:" :
           fmap
             (showTextonym wl)
             longer
         )

------------------------- DISPLAY ------------------------
showTextonym :: Int -> [(String, String)] -> String
showTextonym w ts =
  concat
    [ rjust w ' ' (snd (head ts)),
      " -> ",
      unwords $ fmap fst ts
    ]
  where
    rjust n c = (drop . length) <*> (replicate n c <>)
