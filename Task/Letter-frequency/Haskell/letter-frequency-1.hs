import Data.List

main = readFile "freq.hs" >>= mapM_ (\x -> print (head x, length x)) . group . sort
