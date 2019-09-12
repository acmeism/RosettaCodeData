import Data.List (groupBy, sortBy, intercalate)

type Item = (Int, String)

type ItemList = [Item]

type ItemGroups = [ItemList]

type RankItem a = (a, Int, String)

type RankItemList a = [RankItem a]

-- make sure the input is ordered and grouped by score
prepare :: ItemList -> ItemGroups
prepare = groupBy gf . sortBy (flip compare)
  where
    gf (a, _) (b, _) = a == b

-- give an item a rank
rank
  :: Num a
  => a -> Item -> RankItem a
rank n (a, b) = (n, a, b)

-- ranking methods
standard, modified, dense, ordinal :: ItemGroups -> RankItemList Int
standard = ms 1
  where
    ms _ [] = []
    ms n (x:xs) = (rank n <$> x) ++ ms (n + length x) xs

modified = md 1
  where
    md _ [] = []
    md n (x:xs) =
      let l = length x
          nl = n + l
          nl1 = nl - 1
      in (rank nl1 <$> x) ++ md (n + l) xs

dense = md 1
  where
    md _ [] = []
    md n (x:xs) = map (rank n) x ++ md (n + 1) xs

ordinal = zipWith rank [1 ..] . concat

fractional :: ItemGroups -> RankItemList Double
fractional = mf 1.0
  where
    mf _ [] = []
    mf n (x:xs) =
      let l = length x
          o = take l [n ..]
          ld = fromIntegral l
          a = sum o / ld
      in map (rank a) x ++ mf (n + ld) xs

-- sample data
test :: ItemGroups
test =
  prepare
    [ (44, "Solomon")
    , (42, "Jason")
    , (42, "Errol")
    , (41, "Garry")
    , (41, "Bernard")
    , (41, "Barry")
    , (39, "Stephen")
    ]

-- print rank items nicely
nicePrint
  :: Show a
  => String -> RankItemList a -> IO ()
nicePrint xs items = do
  putStrLn xs
  mapM_ np items
  putStr "\n"
  where
    np (a, b, c) = putStrLn $ intercalate "\t" [show a, show b, c]

main :: IO ()
main = do
  nicePrint "Standard:" $ standard test
  nicePrint "Modified:" $ modified test
  nicePrint "Dense:" $ dense test
  nicePrint "Ordinal:" $ ordinal test
  nicePrint "Fractional:" $ fractional test
