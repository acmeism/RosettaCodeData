sylvester :: [Integer]
sylvester = map s [0 ..]
  where
    s 0 = 2
    s n = succ $ foldr ((*) . s) 1 [0 .. pred n]

main :: IO ()
main = do
  putStrLn "First 10 elements of Sylvester's sequence:"
  putStr $ unlines $ map show $ take 10 sylvester

  putStr "\nSum of reciprocals by sum over map: "
  print $ sum $ map ((1 /) . fromInteger) $ take 10 sylvester

  putStr "Sum of reciprocals by fold: "
  print $ foldr ((+) . (1 /) . fromInteger) 0 $ take 10 sylvester
