mid3 :: Int -> Either String String
mid3 n
  | m < 100 = Left "is too small"
  | even lng = Left "has an even number of digits"
  | otherwise = Right . take 3 $ drop ((lng - 3) `div` 2) s
  where
    m = abs n
    s = show m
    lng = length s

-- TEST --------------------------------------------------------
main :: IO ()
main = do
  let xs =
        [ 123
        , 12345
        , 1234567
        , 987654321
        , 10001
        , -10001
        , -123
        , -100
        , 100
        , -12345
        , 1
        , 2
        , -1
        , -10
        , 2002
        , -2002
        , 0
        ]
      w = maximum $ (length . show) <$> xs
  (putStrLn . unlines) $
    (\n ->
        justifyRight w ' ' (show n) ++
        " -> " ++ either ((>>= id) . ("(" :) . (: [")"])) id (mid3 n)) <$>
    xs
  where
    justifyRight :: Int -> Char -> String -> String
    justifyRight n c s = drop (length s) (replicate n c ++ s)
