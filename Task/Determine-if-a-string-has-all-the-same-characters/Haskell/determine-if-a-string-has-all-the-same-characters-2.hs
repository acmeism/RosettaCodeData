import Data.List (findIndex)

inconsistentChar :: Eq a => [a] -> Maybe (Int, a)
inconsistentChar [] = Nothing
inconsistentChar xs@(x:_) = findIndex (x /=) xs >>= Just . ((,) <*> (xs !!))
