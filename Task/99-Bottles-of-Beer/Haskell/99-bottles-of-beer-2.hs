import qualified Char

main = putStr $ concat
   [up (bob n) ++ wall ++ ", " ++ bob n ++ ".\n" ++
    pass n ++ bob (n - 1) ++ wall ++ ".\n\n" |
    n <- [99, 98 .. 0]]
   where bob n = (num n) ++ " bottle" ++ (s n) ++ " of beer"
         wall = " on the wall"
         pass 0 = "Go to the store and buy some more, "
         pass _ = "Take one down and pass it around, "
         up (x : xs) = Char.toUpper x : xs
         num (-1) = "99"
         num 0    = "no more"
         num n    = show n
         s 1 = ""
         s _ = "s"
