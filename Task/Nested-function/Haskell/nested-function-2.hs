makeList :: String -> String
makeList separator =
  let makeItem = (<>) . (<> separator) . show
   in unlines $ zipWith makeItem [1 ..] ["First", "Second", "Third"]

main :: IO ()
main = putStrLn $ makeList ". "
