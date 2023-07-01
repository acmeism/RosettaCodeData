--Calculate squares, testing for the last 6 digits
findBabbageNumber :: Integer
findBabbageNumber =
  head (filter ((269696 ==) . flip mod 1000000 . (^ 2)) [1 ..])

main :: IO ()
main =
  (putStrLn . unwords)
    (zipWith
       (++)
       (show <$> ([id, (^ 2)] <*> [findBabbageNumber]))
       [" ^ 2 equals", " !"])
