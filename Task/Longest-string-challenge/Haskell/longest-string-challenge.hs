module Main where

import           System.Environment

cmp :: String -> String -> Ordering
cmp [] []         = EQ
cmp [] (_:_)      = LT
cmp (_:_) []      = GT
cmp (_:xs) (_:ys) = cmp xs ys

longest :: String -> String
longest = longest' "" "" . lines
  where
    longest' acc l []         = acc
    longest' [] l (x:xs)      = longest' x x xs
    longest' acc l (x:xs) = case cmp l x of
                                   LT -> longest' x x xs
                                   EQ -> longest' (acc ++ '\n':x) l xs
                                   GT -> longest' acc l xs

main :: IO ()
main = do
  (file:_) <- getArgs
  contents <- readFile file
  putStrLn $ longest contents
