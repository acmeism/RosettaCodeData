powers m = map (^ m) [0..]

filtered (x:xs) (y:ys) | x > y = filtered (x:xs) ys
                       | x < y = x : filtered xs (y:ys)
                       | otherwise = filtered xs (y:ys)

squares = powers 2
cubes = powers 3
f = filtered squares cubes

main :: IO ()
main = print $ take 10 $ drop 20 $ f
