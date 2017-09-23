import Data.List (intersperse)

-- Top down, each row after the first is an XOR / Rule90 rewrite.
-- Bottom up, each line above the base is indented 1 more space.
sierpinski :: Int -> String
sierpinski = fst . foldr spacing ([], []) . rule90 . (2 ^)
  where
    rule90 = scanl next "*" . enumFromTo 1 . subtract 1
      where
        next = const . ((zipWith xor . (' ' :)) <*> (++ " "))
        xor l r
          | l == r = ' '
          | otherwise = '*'
    spacing x (s, w) = (concat [w, intersperse ' ' x, "\n", s], w ++ " ")

main :: IO ()
main = putStr $ sierpinski 4
