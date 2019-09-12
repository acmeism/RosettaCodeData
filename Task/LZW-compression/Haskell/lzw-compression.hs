import Data.List (elemIndex, tails)
import Data.Maybe (fromJust)

doLZW :: Eq a => [a] -> [a] -> [Int]
doLZW _ [] = []
doLZW as (x:xs) = lzw (return <$> as) [x] xs
  where
    lzw a w [] = [fromJust $ elemIndex w a]
    lzw a w (x:xs)
      | w_ `elem` a = lzw a w_ xs
      | otherwise = fromJust (elemIndex w a) : lzw (a ++ [w_]) [x] xs
      where
        w_ = w ++ [x]

undoLZW :: [a] -> [Int] -> [a]
undoLZW _ [] = []
undoLZW a cs =
  cs >>=
  (!!)
    (foldl
       ((.) <$> (++) <*>
        (\x xs -> return (((++) <$> head <*> take 1 . last) ((x !!) <$> xs))))
       (return <$> a)
       (take2 cs))

take2 :: [a] -> [[a]]
take2 xs = filter ((2 ==) . length) (take 2 <$> tails xs)

main :: IO ()
main = do
  print $ doLZW ['\0' .. '\255'] "TOBEORNOTTOBEORTOBEORNOT"
  print $
    undoLZW
      ['\0' .. '\255']
      [84, 79, 66, 69, 79, 82, 78, 79, 84, 256, 258, 260, 265, 259, 261, 263]
  print $
    ((==) <*> ((.) <$> undoLZW <*> doLZW) ['\NUL' .. '\255'])
      "TOBEORNOTTOBEORTOBEORNOT"
