import Data.Char

count :: Int -> [Int] -> Int
count x = length . filter (x ==)

isSelfDescribing :: Integer -> Bool
isSelfDescribing n = nu == f
  where
    nu = digitToInt <$> show n
    f = (`count` nu) <$> [0 .. length nu - 1]

main :: IO ()
main = do
  print $
    isSelfDescribing <$>
    [1210, 2020, 21200, 3211000, 42101000, 521001000, 6210001000]
  print $ filter isSelfDescribing [0 .. 4000000]
