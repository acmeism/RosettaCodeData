add3 :: Int -> Int-> Int-> Int
add3 x y z = add2 x y + z

add2 :: Int -> Int -> Int
add2 x y = x + y

main :: putStrLn(show (add3 5 6 5))
