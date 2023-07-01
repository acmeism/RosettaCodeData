import Data.Char (digitToInt)

isMunchausen :: Int -> Bool
isMunchausen =
  (==)
    <*> foldr ((+) . (id >>=) (^) . digitToInt) 0 . show

main :: IO ()
main = print $ filter isMunchausen [1 .. 5000]
