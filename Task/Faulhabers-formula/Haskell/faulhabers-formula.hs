import Data.Ratio ((%), numerator, denominator)
import Data.List (intercalate, transpose)
import Data.Bifunctor (bimap)
import Data.Char (isSpace)
import Data.Monoid ((<>))
import Data.Bool (bool)

------------------------- FAULHABER ------------------------
faulhaber :: [[Rational]]
faulhaber =
  tail $
  scanl
    (\rs n ->
        let xs = zipWith ((*) . (n %)) [2 ..] rs
        in 1 - sum xs : xs)
    []
    [0 ..]

polynomials :: [[(String, String)]]
polynomials = fmap ((ratioPower =<<) . reverse . flip zip [1 ..]) faulhaber


---------------------------- TEST --------------------------
main :: IO ()
main = (putStrLn . unlines . expressionTable . take 10) polynomials


--------------------- EXPRESSION STRINGS -------------------

-- Rows of (Power string, Ratio string) tuples -> Printable lines
expressionTable :: [[(String, String)]] -> [String]
expressionTable ps =
  let cols = transpose (fullTable ps)
  in expressionRow <$>
     zip
       [0 ..]
       (transpose $
        zipWith
          (\(lw, rw) col ->
              fmap (bimap (justifyLeft lw ' ') (justifyLeft rw ' ')) col)
          (colWidths cols)
          cols)

-- Value pair -> String pair (lifted into list for use with >>=)
ratioPower :: (Rational, Integer) -> [(String, String)]
ratioPower (nd, j) =
  let (num, den) = ((,) . numerator <*> denominator) nd
      sn
        | num == 0 = []
        | (j /= 1) = ("n^" <> show j)
        | otherwise = "n"
      sr
        | num == 0 = []
        | den == 1 && num == 1 = []
        | den == 1 = show num <> "n"
        | otherwise = intercalate "/" [show num, show den]
      s = sr <> sn
  in bool [(sn, sr)] [] (null s)

-- Rows of uneven length -> All rows padded to length of longest
fullTable :: [[(String, String)]] -> [[(String, String)]]
fullTable xs =
  let lng = maximum $ length <$> xs
  in (<>) <*> (flip replicate ([], []) . (-) lng . length) <$> xs

justifyLeft :: Int -> Char -> String -> String
justifyLeft n c s = take n (s <> replicate n c)

-- (Row index, Expression pairs) -> String joined by conjunctions
expressionRow :: (Int, [(String, String)]) -> String
expressionRow (i, row) =
  concat
    [ show i
    , " ->  "
    , foldr
        (\s a -> concat [s, bool " + " " " (blank a || head a == '-'), a])
        []
        (polyTerm <$> row)
    ]

-- (Power string, Ratio String) -> Combined string with possible '*'
polyTerm :: (String, String) -> String
polyTerm (l, r)
  | blank l || blank r = l <> r
  | head r == '-' = concat ["- ", l, " * ", tail r]
  | otherwise = intercalate " * " [l, r]

blank :: String -> Bool
blank = all isSpace

-- Maximum widths of power and ratio elements in each column
colWidths :: [[(String, String)]] -> [(Int, Int)]
colWidths =
  fmap
    (foldr
       (\(ls, rs) (lMax, rMax) -> (max (length ls) lMax, max (length rs) rMax))
       (0, 0))

-- Length of string excluding any leading '-'
unsignedLength :: String -> Int
unsignedLength xs =
  let l = length xs
  in bool (bool l (l - 1) ('-' == head xs)) 0 (0 == l)
