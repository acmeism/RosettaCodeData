str_poly l = intercalate " + " $ terms l
  where term v 0 = show v
        term 1 1 = "x"
        term v 1 = (show v) ++ "x"
        term 1 p = "x^" ++ (show p)
        term v p = (show v) ++ "x^" ++ (show p)

        terms :: Fractional a => [a] -> [String]
        terms [] = []
        terms (0:t) = terms t
        terms (h:t) = (term h (length t)) : (terms t)
