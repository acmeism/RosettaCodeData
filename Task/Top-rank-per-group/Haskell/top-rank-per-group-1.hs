import Data.List (sortBy, groupBy)

import Text.Printf (printf)

import Data.Ord (comparing)

import Data.Function (on)

type ID = Int

type DEP = String

type NAME = String

type SALARY = Double

data Employee = Employee
  { nr :: ID
  , dep :: DEP
  , name :: NAME
  , sal :: SALARY
  }

employees :: [Employee]
employees =
  fmap
    (\(i, d, n, s) -> Employee i d n s)
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

firstN :: Int
       -> (Employee -> DEP)
       -> (Employee -> SALARY)
       -> [Employee]
       -> [[Employee]]
firstN n o1 o2 x =
  fmap
    (take n . sortBy (comparingDown o2))
    (groupBy (groupingOn o1) (sortBy (comparing o1) x))

groupingOn
  :: Eq a1
  => (a -> a1) -> a -> a -> Bool
groupingOn = ((==) `on`)

comparingDown
  :: Ord a
  => (b -> a) -> b -> b -> Ordering
comparingDown = flip . comparing

main :: IO ()
main = do
  printf "%-16s %3s %10s\n" "NAME" "DEP" "TIP"
  putStrLn $ replicate 31 '='
  mapM_ (traverse ((printf "%-16s %3s %10.2g\n" . name) <*> dep <*> sal)) $
    firstN 3 dep sal employees
