parse = map (map read . words) . lines
f x y z = x + max y z
g xs ys = zipWith3 f xs ys $ tail ys
solve = head . foldr1 g
main = readFile "triangle.txt" >>= print . solve . parse
