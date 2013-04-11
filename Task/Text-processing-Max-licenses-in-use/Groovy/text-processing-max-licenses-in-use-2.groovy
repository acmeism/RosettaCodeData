import Data.List

main = do
  f <- readFile "./../Puzzels/Rosetta/inout.txt"
  let (ioo,dt) = unzip. map ((\(_:io:_:t:_)-> (io,t)). words) . lines $ f
      cio = drop 1 . scanl (\c io -> if io == "IN" then pred c else succ c) 0 $ ioo
      mo = maximum cio
  putStrLn $ "Maximum simultaneous license use is " ++ show mo ++ " at:"
  mapM_ (putStrLn . (dt!!)) . elemIndices mo $ cio
