makeList :: String -> String
makeList separator =
  let makeItem = unlines . zipWith ((<>) . (<> separator) . show) [1..]
   in makeItem ["First", "Second", "Third"]

main :: IO ()
main = putStrLn $ makeList ". "
