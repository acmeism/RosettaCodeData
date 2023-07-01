main :: IO ()
main =
  mapM_ print $
  uncurry cartProd <$>
  [([1, 2], [3, 4]), ([3, 4], [1, 2]), ([1, 2], []), ([], [1, 2])]
