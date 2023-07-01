dotProduct :: Num a => [a] -> [a] -> Maybe a
dotProduct a b
  | length a == length b = Just $ dp a b
  | otherwise = Nothing
    where
      dp x y = sum $ zipWith (*) x y


main :: IO ()
main = print n
  where
    Just n = dotProduct [1, 3, -5] [4, -2, -1]
