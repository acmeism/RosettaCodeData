spellOrdinal :: Integer -> String
spellOrdinal n
 | n <=   0  = "not ordinal"
 | n <   20  = small n
 | n < 100   = case divMod n 10 of
     (k, 0) -> spellInteger (10*k) ++ "th"
     (k, m) -> spellInteger (10*k) ++ "-" ++ spellOrdinal m
 | n < 1000 = case divMod n 100 of
     (k, 0) -> spellInteger (100*k) ++ "th"
     (k, m) -> spellInteger (100*k) ++ " and " ++ spellOrdinal m
 | otherwise = case divMod n 1000 of
     (k, 0) -> spellInteger (1000*k) ++ "th"
     (k, m) -> spellInteger (k*1000) ++ s ++ spellOrdinal m
       where s = if m < 100 then " and " else ", "
  where
   small = ([ undefined, "first", "second", "third", "fourth", "fifth"
            , "sixth", "seventh", "eighth", "nineth", "tenth", "eleventh"
            , "twelveth", "thirteenth", "fourteenth", "fifteenth", "sixteenth"
            , "seventeenth", "eighteenth", "nineteenth"] !!) . fromEnum
