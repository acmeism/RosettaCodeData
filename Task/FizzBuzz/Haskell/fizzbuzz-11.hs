wordthing :: [(Int, String)] -> Int -> String
wordthing lst n =
  if matches == [] then
    show n
  else
    concat $ map snd matches
  where matches = filter (\x -> n `mod` (fst x) == 0) lst

fizzbuzz :: Int -> String
fizzbuzz = wordthing [(3, "Fizz"), (5, "Buzz")]

main = do
  mapM_ (putStrLn . fizzbuzz) [1..100]
