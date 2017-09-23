main :: IO ()
main =
  putStrLn . unlines $
  [ show . foldr (+)    0  -- sum
  , show . foldr (*)    1  -- product
  , foldr ((++) . show) "" -- concatenation
  ] <*>
  [[1 .. 10]]
