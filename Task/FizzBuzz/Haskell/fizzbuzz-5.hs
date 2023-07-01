import Control.Applicative ( ZipList(ZipList, getZipList) )

fizzBuzz :: [String]
fizzBuzz =
  getZipList $ go <$>
    ZipList (cycle $ replicate 2 [] <> ["fizz"]) <*>
    ZipList (cycle $ replicate 4 [] <> ["buzz"]) <*>
    ZipList (show <$> [1 ..])

go :: String -> String -> String -> String
go f b n
  | null f && null b = n
  | otherwise = f <> b


main :: IO ()
main = mapM_ putStrLn $ take 100 fizzBuzz
