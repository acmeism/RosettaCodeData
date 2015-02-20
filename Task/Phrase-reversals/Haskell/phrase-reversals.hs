phrase = "rosetta code phrase reversal"

main = do
  putStrLn $ reverse phrase
  putStrLn $ unwords . map reverse . words $ phrase
  putStrLn $ unwords . reverse . words $ phrase
