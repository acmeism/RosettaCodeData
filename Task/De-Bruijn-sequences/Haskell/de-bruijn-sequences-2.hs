import Control.Monad (replicateM)

main = do
  let symbols = ['0'..'9']
  let db = deBruijn symbols 4
  putStrLn $ "The length of de Bruijn sequence: " ++ show (length db)
  putStrLn $ "The first 130 symbols are:\n" ++ show (take 130 db)
  putStrLn $ "The last 130 symbols are:\n" ++ show (drop (length db - 130) db)

  let words = replicateM 4 symbols
  let validate db  = filter (not . (`isInfixOf` db)) words
  putStrLn $ "Words not in the sequence: " ++ unwords (validate db)

  let db' = a ++ ('.': tail b) where (a,b) = splitAt 4444 db
  putStrLn $ "Words not in the corrupted sequence: " ++ unwords (validate db')
