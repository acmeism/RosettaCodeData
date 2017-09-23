import qualified Data.Map as M

import Data.Ord (comparing)
import Control.Monad (join)
import Data.Maybe (fromJust)
import Data.List (nub, sortBy, sort, intercalate, transpose)

mapNames, mapDepts :: M.Map Int String
[mapNames, mapDepts] = pure readPairs <*> [nameKV, deptKV] <*> [xs]

mapSalaries :: M.Map Int Int
mapSalaries = readPairs salaryKV xs

highSalaryKeys :: Int -> String -> [(Int, Int)]
highSalaryKeys n dept =
  take n $
  sortBy ((flip . comparing) snd) $
  (,) <*> (fromJust . flip M.lookup mapSalaries) <$>
  M.keys (M.filter (== dept) mapDepts)

reportLines :: String -> [(Int, Int)] -> [[String]]
reportLines dept =
  fmap (\(k, n) -> [fromJust $ M.lookup k mapNames, dept, show n])

xs :: [(Int, String, String, Int)]
xs =
  [ (1001, "AB", "Janssen A.H.", 41000)
  , (101, "KA", "'t Woud B.", 45000)
  , (1013, "AB", "de Bont C.A.", 65000)
  , (1101, "CC", "Modaal A.M.J.", 30000)
  , (1203, "AB", "Anders H.", 50000)
  , (100, "KA", "Ezelbips P.J.", 52000)
  , (1102, "CC", "Zagt A.", 33000)
  , (1103, "CC", "Ternood T.R.", 21000)
  , (1104, "CC", "Lageln M.", 23000)
  , (1105, "CC", "Amperwat A.", 19000)
  , (1106, "CC", "Boon T.J.", 25000)
  , (1107, "CC", "Beloop L.O.", 31000)
  , (1009, "CD", "Janszoon A.", 38665)
  , (1026, "CD", "Janszen H.P.", 41000)
  , (1011, "CC", "de Goeij J.", 39000)
  , (106, "KA", "Pragtweik J.M.V.", 42300)
  , (111, "KA", "Bakeuro S.", 31000)
  , (105, "KA", "Clubdrager C.", 39800)
  , (104, "KA", "Karendijk F.", 23000)
  , (107, "KA", "Centjes R.M.", 34000)
  , (119, "KA", "Tegenstroom H.L.", 39000)
  , (1111, "CD", "Telmans R.M.", 55500)
  , (1093, "AB", "de Slegte S.", 46987)
  , (1199, "CC", "Uitlaat G.A.S.", 44500)
  ]

readPairs
  :: Ord k
  => (a1 -> (k, a)) -> [a1] -> M.Map k a
readPairs f xs = M.fromList $ f <$> xs

nameKV, deptKV :: (Int, String, String, Int) -> (Int, String)
nameKV (k, _, name, _) = (k, name)

deptKV (k, dept, _, _) = (k, dept)

salaryKV :: (Int, String, String, Int) -> (Int, Int)
salaryKV (k, _, _, salary) = (k, salary)

table :: String -> [[String]] -> [String]
table delim rows =
  let justifyLeft c n s = take n (s ++ replicate n c)
      justifyRight c n s = drop (length s) (replicate n c ++ s)
  in intercalate delim <$>
     transpose
       ((fmap =<< justifyLeft ' ' . maximum . fmap length) <$> transpose rows)

main :: IO ()
main =
  (putStrLn . unlines)
    (table
       "   "
       (join
          (reportLines <*> highSalaryKeys 3 <$> (sort . nub) (M.elems mapDepts))))
