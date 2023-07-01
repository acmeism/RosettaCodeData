import Data.List (groupBy, intersperse, sort, transpose)
import Data.Char (ord, toUpper)
import Data.Function(on)
import Numeric (showHex)


hexFromChar :: Char -> String
hexFromChar c = map toUpper $ showHex (ord c) ""

string :: String -> String
string xs = ('\"' : xs) <> "\""

char :: Char -> String
char c = ['\'', c, '\'']

size :: String -> String
size = show . length

positions :: (Int, Int) -> String
positions (a, b) = show a <> " " <> show b

forTable :: String -> [String]
forTable xs = string xs : go (allUnique xs)
  where
    go Nothing = [size xs, "yes", "", "", ""]
    go (Just (u, ij)) = [size xs, "no", char u, hexFromChar u, positions ij]

showTable :: Bool -> Char -> Char -> Char -> [[String]] -> String
showTable _ _ _ _ [] = []
showTable header ver hor sep contents =
  unlines $
  hr :
  (if header
     then z : hr : zs
     else intersperse hr zss) <>
  [hr]
  where
    vss = map (map length) contents
    ms = map maximum (transpose vss) :: [Int]
    hr = concatMap (\n -> sep : replicate n hor) ms <> [sep]
    top = replicate (length hr) hor
    bss = map (map (`replicate` ' ') . zipWith (-) ms) vss
    zss@(z:zs) =
      zipWith
        (\us bs -> concat (zipWith (\x y -> (ver : x) <> y) us bs) <> [ver])
        contents
        bss

table xs =
  showTable
    True
    '|'
    '-'
    '+'
    (["string", "length", "all unique", "1st diff", "hex", "positions"] :
     map forTable xs)

allUnique
  :: (Ord b, Ord a, Num b, Enum b)
  => [a] -> Maybe (a, (b, b))
allUnique xs = go . groupBy (on (==) fst) . sort . zip xs $ [0 ..]
  where
    go [] = Nothing
    go ([_]:us) = go us
    go (((u, i):(_, j):_):_) = Just (u, (i, j))

main :: IO ()
main =
  putStrLn $
  table ["", ".", "abcABC", "XYZ ZYX", "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"]
