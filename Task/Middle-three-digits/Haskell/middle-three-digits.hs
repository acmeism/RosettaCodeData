------------------- MIDDLE THREE DIGITS ------------------

mid3 :: Int -> Either String String
mid3 n
  | m < 100 = Left "too small"
  | even lng = Left "even number of digits"
  | otherwise = Right . take 3 $ drop ((lng - 3) `div` 2) s
  where
    m = abs n
    s = show m
    lng = length s

--------------------------- TEST -------------------------
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
      w = maximum $ length . show <$> xs
  (putStrLn . unlines) $
    (\n ->
       justifyRight w ' ' (show n) <>
       " -> " <> either (concat . ("(" :) . (: [")"])) id (mid3 n)) <$>
    xs

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
