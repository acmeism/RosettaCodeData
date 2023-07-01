-------------------------- CANTOR ------------------------

cantor :: [String] -> [String]
cantor = (go =<<)
  where
    go x
      | '█' == head x = [block, replicate m ' ', block]
      | otherwise = [x]
      where
        m = quot (length x) 3
        block = take m x


--------------------------- TEST -------------------------
main :: IO ()
main = putStrLn $ cantorLines 5


------------------------- DISPLAY ------------------------
cantorLines :: Int -> String
cantorLines =
  unlines . (concat <$>)
    . ( take
          <*> ( iterate cantor
                  . return
                  . flip replicate '█'
                  . (3 ^)
                  . pred
              )
      )
