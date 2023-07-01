import Data.List

groupon f x y = f x == f y

main = do
  f <- readFile "./../Puzzels/Rosetta/unixdict.txt"
  let  words = lines f
       wix = groupBy (groupon fst) . sort $ zip (map sort words) words
       mxl = maximum $ map length wix
  mapM_ (print . map snd) . filter ((==mxl).length) $ wix
