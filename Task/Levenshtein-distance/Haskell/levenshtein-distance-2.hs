levenshtein :: Eq a => [a] -> [a] -> Int
levenshtein s1 [] = length s1
levenshtein [] s2 = length s2
levenshtein s1@(s1Head:s1Tail) s2@(s2Head:s2Tail)
    | s1Head == s2Head = levenshtein s1Tail s2Tail
    | otherwise        = 1 + minimum [score1, score2, score3]
        where score1 = levenshtein s1Tail s2Tail
              score2 = levenshtein s1 s2Tail
              score3 = levenshtein s1Tail s2

main :: IO ()
main = print (levenshtein "kitten" "sitting")
