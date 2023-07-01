import Data.List (sortOn)

main :: IO ()
main = print $ sortOn show [1 .. 13]
