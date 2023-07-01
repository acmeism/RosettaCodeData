import Data.Char (digitToInt)
import Data.Set (member, insert, empty)

isHappy :: Integer -> Bool
isHappy = p empty
  where
    p _ 1 = True
    p s n
      | n `member` s = False
      | otherwise = p (insert n s) (f n)
    f = sum . fmap ((^ 2) . toInteger . digitToInt) . show

main :: IO ()
main = mapM_ print $ take 8 $ filter isHappy [1 ..]
