type Rule = (Int, String)

----------------- FIZZETC (USING RULE SET) ---------------

fizzEtc :: [(Int, String)] -> [String]
fizzEtc rules = foldr nextLine [] [1 ..]
  where
    nextLine x a
      | null noise = show x : a
      | otherwise = noise : a
      where
        noise = foldl reWrite [] rules
        reWrite s (m, k)
          | 0 == rem x m = s <> k
          | otherwise = s


------------------- TEST OF SAMPLE RULES -----------------
fizzTest :: [String]
fizzTest = fizzEtc [(3, "Fizz"), (5, "Buzz"), (7, "Baxx")]

main :: IO ()
main = mapM_ putStrLn $ take 20 fizzTest
