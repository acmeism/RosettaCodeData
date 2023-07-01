isMatching :: String -> Bool
isMatching = null . foldl aut []
  where
    aut ('[':s) ']' = s
    -- aut ('{':s) '}' = s -- automaton could be extended
    aut s x = x:s
