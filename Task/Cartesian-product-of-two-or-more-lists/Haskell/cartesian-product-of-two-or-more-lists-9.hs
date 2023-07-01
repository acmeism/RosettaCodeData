main :: IO ()
main = do
  mapM_ print $
    cartProdN [[1776, 1789], [7,12], [4, 14, 23], [0,1]]
  putStrLn ""
  print $ cartProdN [[1,2,3], [30], [500, 100]]
  putStrLn ""
  print $ cartProdN [[1,2,3], [], [500, 100]]
