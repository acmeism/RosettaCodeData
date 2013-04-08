main = mapM_ putStrLn $ take 100 fizzbuzz

fizzbuzz = zipWith (\x y -> if null y then show x else y) [1..] fbs

fbs = zipWith (++) (cycle ["","","Fizz"]) (cycle ["","","","","Buzz"])
