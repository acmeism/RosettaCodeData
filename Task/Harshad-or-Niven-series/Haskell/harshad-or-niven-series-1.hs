import Data.Char (digitToInt)

harshads :: [Int]
harshads =
  let digsum = sum . map digitToInt . show
  in filter ((0 ==) . (mod <*> digsum)) [1 ..]

main :: IO ()
main = mapM_ print [take 20 harshads, [(head . filter (> 1000)) harshads]]
