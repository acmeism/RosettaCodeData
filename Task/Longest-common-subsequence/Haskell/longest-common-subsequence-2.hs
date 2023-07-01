import qualified Data.MemoCombinators as M

lcs = memoize lcsm
       where
         lcsm [] _ = []
         lcsm _ [] = []
         lcsm (x:xs) (y:ys)
           | x == y    = x : lcs xs ys
           | otherwise = maxl (lcs (x:xs) ys) (lcs xs (y:ys))

maxl x y = if length x > length y then x else y
memoize = M.memo2 mString mString
mString = M.list M.char -- Chars, but you can specify any type you need for the memo
