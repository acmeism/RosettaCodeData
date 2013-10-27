main = mapM_ putStrLn $ take 100 $ zipWith show_number_or_fizzbuzz [1..] fizz_buzz_list

show_number_or_fizzbuzz x y = if null y then show x else y

fizz_buzz_list = zipWith (++) (cycle ["","","Fizz"]) (cycle ["","","","","Buzz"])
