import Data.Monoid ((<>))
import Data.Array (Array, listArray, (!))
import Data.List (unfoldr, transpose, intercalate)

-- ARBITRARY RADICES ----------------------------------------------------------
bases :: [Int]
bases = abs <$> [2, 7, 8, 10, 12, 16, 32]

tableRows :: [[String]]
tableRows = ((([baseDigits] <*> bases) <*>) . return) <$> [1 .. 33]

digits :: Array Int Char
digits = listArray (0, 35) (['0' .. '9'] <> ['A' .. 'Z'])

baseDigits :: Int -> Int -> String
baseDigits base
  | base > 36 = const "Needs glyphs beyond Z"
  | otherwise = reverse . unfoldr remQuot
  where
    remQuot 0 = Nothing
    remQuot n =
      let (q, r) = quotRem n base
      in Just (digits ! r, q)

-- TEST AND TABULATION---------------------------------------------------------
table :: String -> [[String]] -> [String]
table delim rows =
  intercalate delim <$>
  transpose
    ((\col ->
         let width = maximum (length <$> col)
             justifyRight n c s = drop (length s) (replicate n c <> s)
         in justifyRight width ' ' <$> col) <$>
     transpose rows)

main :: IO ()
main =
  mapM_
    putStrLn
    (table " " (([(show <$>), (const "----" <$>)] <*> [bases]) <> tableRows))
