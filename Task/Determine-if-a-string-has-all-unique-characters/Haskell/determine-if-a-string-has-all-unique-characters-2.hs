import Data.List (groupBy, intercalate, sortOn)
import Data.Function (on)
import Numeric (showHex)
import Data.Char (ord)


------------- INDICES OF DUPLICATED CHARACTERS -----------

duplicatedCharIndices :: String -> Maybe (Char, [Int])
duplicatedCharIndices s
  | null duplicates = Nothing
  | otherwise =
    Just $
    ((,) . (snd . head) <*> fmap fst) (head (sortOn (fst . head) duplicates))
  where
    duplicates =
      filter ((1 <) . length) $
      groupBy (on (==) snd) $ sortOn snd $ zip [0 ..] s


--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
  fTable
    "First duplicated character, if any:"
    (fmap (<>) show <*> ((" (" <>) . (<> ")") . show . length))
    (maybe
       "None"
       (\(c, ixs) ->
           unwords
             [ show c
             , "(0x" <> showHex (ord c) ") at"
             , intercalate ", " (show <$> ixs)
             ]))
    duplicatedCharIndices
    ["", ".", "abcABC", "XYZ ZYX", "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"]


------------------------- DISPLAY ------------------------

fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  unlines $
  s : fmap (((<>) . rjust w ' ' . xShow) <*> ((" -> " <>) . fxShow . f)) xs
  where
    rjust n c = drop . length <*> (replicate n c <>)
    w = maximum (length . xShow <$> xs)
