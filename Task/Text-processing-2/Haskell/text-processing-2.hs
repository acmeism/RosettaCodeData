import Data.List (nub, (\\))

data Record = Record {date :: String, recs :: [(Double, Int)]}

duplicatedDates rs = rs \\ nub rs

goodRecords = filter ((== 24) . length . filter ((>= 1) . snd) . recs)

parseLine l = let ws = words l in Record (head ws) (mapRecords (tail ws))

mapRecords [] = []
mapRecords [_] = error "invalid data"
mapRecords (value:flag:tail) = (read value, read flag) : mapRecords tail

main = do
  inputs <- (map parseLine . lines) `fmap` readFile "readings.txt"
  putStr (unlines ("duplicated dates:": duplicatedDates (map date inputs)))
  putStrLn ("number of good records: " ++ show (length $ goodRecords inputs))
