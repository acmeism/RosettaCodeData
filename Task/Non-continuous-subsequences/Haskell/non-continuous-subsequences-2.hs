continuous = null . dropWhile not . dropWhile id . dropWhile not
ncs xs = map (map fst . filter snd . zip xs) $
           filter (not . continuous) $
             mapM (const [True,False]) xs
