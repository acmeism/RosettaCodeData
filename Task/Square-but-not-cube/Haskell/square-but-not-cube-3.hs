isCube :: Int -> Bool
isCube =
  (==)
    <*> ((^ 3) . round . (** (1 / 3)) . fromIntegral)

squares :: Int -> Int -> [Int]
squares m n = (>>= id) (*) <$> [m .. n]

--------------------------- TEST -------------------------
main :: IO ()
main =
  (putStrLn . unlines) $
    (<>) . show <*> label <$> squares 1 33

label :: Int -> String
label n
  | isCube n = " (also cube)"
  | otherwise = ""
