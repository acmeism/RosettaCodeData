import Data.List (unfoldr)
import Data.Tuple (swap)
import Data.Bool (bool)

harshads :: [Int]
harshads = filter ((0 ==) . (rem <*> digitSum)) [1 ..]

digitSum :: Int -> Int
digitSum =
  sum . unfoldr ((bool Nothing . Just . swap . flip quotRem 10) <*> (0 <))

main :: IO ()
main = mapM_ print $ [take 20, take 1 . dropWhile (<= 1000)] <*> [harshads]
