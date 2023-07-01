import qualified Safe as S
import qualified Data.Map.Strict as M
import Data.List (intercalate, foldl') --'
import Data.Ord (comparing)
import Numeric (showHex)
import Data.Char (ord)


----------- INDICES OF ANY DUPLICATED CHARACTERS ---------

duplicatedCharIndices :: String -> Maybe (Char, [Int])
duplicatedCharIndices xs =
  S.minimumByMay
    (comparing (head . snd))
    (M.toList
       (M.filter
          ((1 <) . length)
          (foldl' --'
             (\a (i, c) -> M.insert c (maybe [i] (<> [i]) (M.lookup c a)) a)
             M.empty
             (zip [0 ..] xs))))

-- OR, fusing filter, toList, and minimumByMay down to a single fold:
duplicatedCharIndices_ :: String -> Maybe (Char, [Int])
duplicatedCharIndices_ xs =
  M.foldrWithKey
    go
    Nothing
    (foldl' --'
       (\a (i, c) -> M.insert c (maybe [i] (<> [i]) (M.lookup c a)) a)
       M.empty
       (zip [0 ..] xs))
  where
    go k [_] mb = mb -- Unique
    go k xs Nothing = Just (k, xs) -- Duplicated
    go k xs@(x:_) (Just (c, ys@(y:_)))
      | x < y = Just (k, xs) -- Earlier duplication
      | otherwise = Just (c, ys)

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
  fTable
    "First duplicated character, if any:"
    ((<>) <$> show <*> ((" (" <>) . (<> ")") . show . length))
    (maybe
       "None"
       (\(c, ixs) ->
           unwords
             [ show c
             , "(0x" <> showHex (ord c) ") at"
             , intercalate ", " (show <$> ixs)
             ]))
    duplicatedCharIndices_
    ["", ".", "abcABC", "XYZ ZYX", "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"]

------------------------- DISPLAY ------------------------
fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  unlines $
  s : fmap (((<>) . rjust w ' ' . xShow) <*> ((" -> " <>) . fxShow . f)) xs
  where
    rjust n c = drop . length <*> (replicate n c <>)
    w = maximum (length . xShow <$> xs)
