import Data.List (unfoldr)
import Data.List.Split (chunksOf)
import Data.Maybe (mapMaybe)
import Data.Time.Calendar (Day, fromGregorianValid)
import Data.Tuple (swap)

-------------------- PALINDROMIC DATES -------------------

palinDates :: [Day]
palinDates = mapMaybe palinDay [2021 .. 9999]

palinDay :: Integer -> Maybe Day
palinDay y = fromGregorianValid y m d
  where
    [m, d] = unDigits <$> chunksOf 2
      (reversedDecimalDigits (fromInteger y))


--------------------------- TEST -------------------------
main :: IO ()
main =
  let n = length palinDates
   in putStrLn ("Count of palindromic dates [2021..9999]: "
        <> show n) >>
      putStrLn "\nFirst 15:" >>
      mapM_ print (take 15 palinDates) >>
      putStrLn "\nLast 15:" >>
      mapM_ print (take 15 (drop (n - 15) palinDates))


------------------------- GENERIC ------------------------

reversedDecimalDigits :: Int -> [Int]
reversedDecimalDigits = unfoldr go
  where
    go n
      | 0 < n = Just $ swap (quotRem n 10)
      | otherwise = Nothing

unDigits :: [Int] -> Int
unDigits = foldl ((+) . (10 *)) 0
