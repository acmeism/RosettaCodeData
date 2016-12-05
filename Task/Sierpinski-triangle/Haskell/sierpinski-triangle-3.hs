import Data.List (intersperse)

sierpinski :: Int -> String
sierpinski n = let

    -- Top down, each row after the first is an XOR rewrite
    rule90 n = (scanl next ['*'] [1..n-1]) where
        next line _ = zipWith xor (" " ++ line) (line ++ " ")
        xor l r | l == r = ' ' | otherwise = '*'

    -- Bottom up, each line above the base is indented 1 more space
    in fst (foldr spacing ("", "") (rule90 (2^n))) where
        spacing x (s, w) =
            (concat [w, intersperse ' ' x, "\n", s], w ++ " ")

main = putStr $ sierpinski 4
