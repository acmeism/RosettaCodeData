dotp
  :: Num a
  => [a] -> [a] -> Maybe a
dotp a b
  | length a == length b = Just $ sum (zipWith (*) a b)
  | otherwise = Nothing

main :: IO ()
main = mbPrint $ dotp [1, 3, -5] [4, -2, -1] -- prints 3

mbPrint
  :: Show a
  => Maybe a -> IO ()
mbPrint (Just x) = print x
mbPrint n = print n
