import Data.List ( groupBy )

parseFasta :: FilePath -> IO ()
parseFasta fileName = do
  file <- readFile fileName
  let pairedFasta = readFasta $ lines file
  mapM_ (\(name, code) -> putStrLn $ name ++ ": " ++ code) pairedFasta

readFasta :: [String] -> [(String, String)]
readFasta = pair . map concat . groupBy (\x y -> notName x && notName y)
 where
  notName :: String -> Bool
  notName = (/=) '>' . head

  pair :: [String] -> [(String, String)]
  pair []           = []
  pair (x : y : xs) = (drop 1 x, y) : pair xs
