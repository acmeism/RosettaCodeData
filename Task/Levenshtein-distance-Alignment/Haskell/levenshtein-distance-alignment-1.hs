costs :: String -> String -> [[Int]]
costs s1 s2 = reverse $ reverse <$> matrix
  where
    matrix = scanl transform [0 .. length s1] s2
    transform ns@(n:ns1) c = scanl calc (n + 1) $ zip3 s1 ns ns1
      where
        calc z (c1, x, y) = minimum [ y + 1, z + 1
                                    , x + fromEnum (c1 /= c)]

levenshteinDistance :: String -> String -> Int
levenshteinDistance s1 s2 = head.head $ costs s1 s2
