bellTri :: [[Integer]]
bellTri =
  let f xs = (last xs, xs)
   in map snd (iterate (f . uncurry (scanl (+))) (1, [1]))

bell :: [Integer]
bell = map head bellTri

main :: IO ()
main = do
  putStrLn "First 10 rows of Bell's Triangle:"
  mapM_ print (take 10 bellTri)
  putStrLn "\nFirst 15 Bell numbers:"
  mapM_ print (take 15 bell)
  putStrLn "\n50th Bell number:"
  print (bell !! 49)
