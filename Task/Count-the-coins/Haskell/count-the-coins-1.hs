count :: (Integral t, Integral a) => t -> [t] -> a
count 0 _ = 1
count _ [] = 0
count x (c:coins) =
  sum
    [ count (x - (n * c)) coins
    | n <- [0 .. (quot x c)] ]

main :: IO ()
main = print (count 100 [1, 5, 10, 25])
